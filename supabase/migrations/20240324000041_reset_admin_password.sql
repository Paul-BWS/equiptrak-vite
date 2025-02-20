-- Disable RLS temporarily for this operation
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Reset admin user in auth.users
DO $$
DECLARE
    admin_id uuid;
BEGIN
    -- Delete existing admin user if exists
    DELETE FROM auth.users WHERE email = 'paul@basicwelding.co.uk';
    
    -- Create new admin user with known password
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
        'paul@basicwelding.co.uk',
        crypt('Admin123!', gen_salt('bf')), -- New password: Admin123!
        now(),
        jsonb_build_object(
            'role', 'admin',
            'company_name', 'BWS LTD'
        ),
        now(),
        now(),
        'authenticated',
        (SELECT id FROM auth.instances LIMIT 1)
    )
    RETURNING id INTO admin_id;

    -- Ensure profile exists and matches
    INSERT INTO profiles (
        id,
        email,
        role,
        company_name,
        created_at,
        updated_at
    )
    VALUES (
        admin_id,
        'paul@basicwelding.co.uk',
        'admin',
        'BWS LTD',
        now(),
        now()
    )
    ON CONFLICT (id) DO UPDATE
    SET 
        role = 'admin',
        company_name = 'BWS LTD',
        updated_at = now();

END $$;

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Verify admin exists in both tables
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM auth.users u
        JOIN profiles p ON u.id = p.id
        WHERE u.email = 'paul@basicwelding.co.uk'
        AND p.role = 'admin'
    ) THEN
        RAISE EXCEPTION 'Admin user not properly created';
    END IF;
END $$; 