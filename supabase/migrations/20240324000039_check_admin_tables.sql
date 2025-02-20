-- Check auth.users table
SELECT id, email, role, raw_user_meta_data
FROM auth.users
WHERE email = 'paul@basicwelding.co.uk';

-- Check public.profiles table
SELECT id, email, role, company_name
FROM profiles
WHERE email = 'paul@basicwelding.co.uk';

-- If admin is missing from auth.users, create them
DO $$
DECLARE
    admin_exists boolean;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM auth.users WHERE email = 'paul@basicwelding.co.uk'
    ) INTO admin_exists;

    IF NOT admin_exists THEN
        -- Create admin in auth.users
        INSERT INTO auth.users (
            email,
            encrypted_password,
            email_confirmed_at,
            raw_user_meta_data,
            role
        )
        VALUES (
            'paul@basicwelding.co.uk',
            crypt('admin123', gen_salt('bf')), -- You'll need to change this password
            now(),
            jsonb_build_object('role', 'admin', 'company_name', 'BWS LTD'),
            'authenticated'
        );
    END IF;
END $$;

-- If admin is missing from profiles, create them
DO $$
DECLARE
    admin_id uuid;
BEGIN
    -- Get admin ID from auth.users
    SELECT id INTO admin_id
    FROM auth.users
    WHERE email = 'paul@basicwelding.co.uk';

    IF admin_id IS NOT NULL THEN
        -- Create or update profile
        INSERT INTO profiles (id, email, role, company_name)
        VALUES (
            admin_id,
            'paul@basicwelding.co.uk',
            'admin',
            'BWS LTD'
        )
        ON CONFLICT (id) DO UPDATE
        SET role = 'admin',
            company_name = 'BWS LTD';
    END IF;
END $$; 