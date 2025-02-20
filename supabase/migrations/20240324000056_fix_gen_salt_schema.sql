-- First, drop everything to start fresh
DROP FUNCTION IF EXISTS create_customer(jsonb, jsonb);
DROP EXTENSION IF EXISTS pgcrypto CASCADE;

-- Create pgcrypto in the correct schema
CREATE EXTENSION pgcrypto WITH SCHEMA public;

-- Create the function with proper schema references
CREATE OR REPLACE FUNCTION public.create_customer(
    user_data jsonb,
    profile_data jsonb
)
RETURNS jsonb  -- Changed to return jsonb for better error handling
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
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
        crypt(user_data->>'password', gen_salt('bf')),  -- Simplified call
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

    -- Return success response
    RETURN jsonb_build_object(
        'success', true,
        'user_id', new_user_id,
        'email', user_data->>'email'
    );

EXCEPTION
    WHEN others THEN
        -- If anything fails, ensure we clean up
        IF new_user_id IS NOT NULL THEN
            DELETE FROM auth.users WHERE id = new_user_id;
        END IF;
        RETURN jsonb_build_object(
            'success', false,
            'error', SQLERRM
        );
END;
$$;

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO postgres, authenticated, anon;
GRANT EXECUTE ON FUNCTION public.create_customer(jsonb, jsonb) TO postgres, authenticated, anon;

-- Verify function exists and is accessible
DO $$
BEGIN
    -- Test gen_salt function
    PERFORM gen_salt('bf');
    
    -- Test function exists
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_proc 
        WHERE proname = 'create_customer'
        AND pronamespace = 'public'::regnamespace
    ) THEN
        RAISE EXCEPTION 'create_customer function was not created successfully';
    END IF;
END $$; 