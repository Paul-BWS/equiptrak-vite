-- Enable the pgcrypto extension if not already enabled
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Drop existing function if it exists
DROP FUNCTION IF EXISTS create_customer;

-- Create function to handle customer creation
CREATE OR REPLACE FUNCTION create_customer(
    user_data jsonb,
    profile_data jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    new_user_id uuid;
    current_user_email text;
    admin_emails text[] := ARRAY['paul@basicwelding.co.uk', 'sales@basicwelding.co.uk'];
BEGIN
    -- Get the current user's email from the JWT
    current_user_email := auth.jwt() ->> 'email';
    
    -- Check if user is admin
    IF NOT (current_user_email = ANY(admin_emails)) THEN
        RAISE EXCEPTION 'Unauthorized: Only admins can create users';
    END IF;

    -- Create the auth user
    INSERT INTO auth.users (
        email,
        encrypted_password,
        email_confirmed_at,
        raw_user_meta_data,
        created_at,
        updated_at,
        role,
        instance_id
    )
    VALUES (
        user_data->>'email',
        crypt(user_data->>'password', gen_salt('bf')),
        now(),
        jsonb_build_object(
            'company_name', user_data->>'company_name',
            'role', user_data->>'role',
            'created_by', current_user_email
        ),
        now(),
        now(),
        'authenticated',
        (SELECT id FROM auth.instances LIMIT 1)
    )
    RETURNING id INTO new_user_id;

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

    -- Return the created user's ID
    RETURN jsonb_build_object(
        'user_id', new_user_id,
        'email', user_data->>'email'
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