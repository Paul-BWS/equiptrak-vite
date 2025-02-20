-- Ensure auth.users entry exists and matches profile
DO $$
DECLARE
    profile_id uuid := '42c4aca3-d7bd-49b5-8b7b-1013e9ff92ba';
BEGIN
    -- Check if user exists in auth.users
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE id = profile_id) THEN
        -- Create the auth user with the same ID as the profile
        INSERT INTO auth.users (
            id,
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
            profile_id,
            'paul@basicwelding.co.uk',
            crypt('admin123', gen_salt('bf')), -- You'll need to change this password
            now(),
            jsonb_build_object(
                'role', 'admin',
                'company_name', 'BWS LTD'
            ),
            now(),
            now(),
            'authenticated',
            (SELECT id FROM auth.instances LIMIT 1)
        );
    ELSE
        -- Update existing auth user
        UPDATE auth.users
        SET 
            email_confirmed_at = COALESCE(email_confirmed_at, now()),
            raw_user_meta_data = jsonb_build_object(
                'role', 'admin',
                'company_name', 'BWS LTD'
            ),
            updated_at = now(),
            role = 'authenticated'
        WHERE id = profile_id;
    END IF;

    -- Verify both entries exist and match
    IF NOT EXISTS (
        SELECT 1 
        FROM auth.users u 
        JOIN profiles p ON u.id = p.id 
        WHERE u.id = profile_id 
        AND u.email = 'paul@basicwelding.co.uk'
        AND p.role = 'admin'
    ) THEN
        RAISE EXCEPTION 'Failed to sync auth user with profile';
    END IF;
END $$; 