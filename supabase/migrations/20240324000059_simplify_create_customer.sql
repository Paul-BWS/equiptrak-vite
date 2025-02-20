-- Drop everything to start fresh
DROP FUNCTION IF EXISTS create_customer(jsonb, jsonb);
DROP EXTENSION IF EXISTS pgcrypto CASCADE;

-- Create pgcrypto in auth schema
CREATE EXTENSION IF NOT EXISTS pgcrypto SCHEMA auth;

-- Create the simplified function
CREATE OR REPLACE FUNCTION create_customer(
    user_data jsonb,
    profile_data jsonb
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = auth, public
AS $$
DECLARE
    new_user_id uuid;
    current_user_email text;
    admin_emails text[] := ARRAY['paul@basicwelding.co.uk', 'sales@basicwelding.co.uk'];
BEGIN
    -- Generate UUID first
    new_user_id := gen_random_uuid();
    
    -- Get the current user's email from the JWT
    current_user_email := auth.jwt() ->> 'email';
    
    -- Check if user is admin
    IF NOT (current_user_email = ANY(admin_emails)) THEN
        RAISE EXCEPTION 'Unauthorized: Only admins can create users';
    END IF;

    -- Create the auth user with minimal required fields
    INSERT INTO auth.users (
        id,
        instance_id,
        email,
        encrypted_password,
        email_confirmed_at,
        created_at,
        updated_at,
        role,
        aud,
        raw_app_meta_data,
        raw_user_meta_data
    )
    VALUES (
        new_user_id,
        (SELECT id FROM auth.instances LIMIT 1),
        user_data->>'email',
        auth.crypt(user_data->>'password', auth.gen_salt('bf')),
        now(),
        now(),
        now(),
        'authenticated',
        'authenticated',
        '{"provider": "email", "providers": ["email"]}'::jsonb,
        jsonb_build_object(
            'company_name', user_data->>'company_name',
            'role', user_data->>'role',
            'created_by', current_user_email
        )
    );

    -- Create the profile
    INSERT INTO profiles (
        id,
        email,
        company_name,
        role,
        telephone,
        mobile,
        address,
        city,
        county,
        postcode,
        country,
        contact_name,
        contact_email,
        stored_password
    )
    VALUES (
        new_user_id,
        profile_data->>'email',
        profile_data->>'company_name',
        (profile_data->>'role')::user_role,
        profile_data->>'telephone',
        profile_data->>'mobile',
        profile_data->>'address',
        profile_data->>'city',
        profile_data->>'county',
        profile_data->>'postcode',
        COALESCE(profile_data->>'country', 'United Kingdom'),
        profile_data->>'contact_name',
        profile_data->>'contact_email',
        profile_data->>'stored_password'
    );

EXCEPTION
    WHEN others THEN
        -- If anything fails, ensure we clean up
        IF new_user_id IS NOT NULL THEN
            DELETE FROM auth.users WHERE id = new_user_id;
        END IF;
        RAISE;
END;
$$;

-- Grant necessary permissions
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT EXECUTE ON FUNCTION create_customer(jsonb, jsonb) TO authenticated; 