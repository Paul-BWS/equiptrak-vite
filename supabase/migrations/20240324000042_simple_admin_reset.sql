-- Disable RLS temporarily
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Reset admin user completely
DO $$
DECLARE
    admin_id uuid;
BEGIN
    -- Remove existing admin entries
    DELETE FROM auth.users WHERE email = 'paul@basicwelding.co.uk';
    DELETE FROM profiles WHERE email = 'paul@basicwelding.co.uk';
    
    -- Create new admin user with simple password
    INSERT INTO auth.users (
        email,
        encrypted_password,
        email_confirmed_at,
        raw_user_meta_data,
        created_at,
        updated_at,
        role,
        instance_id,
        confirmed_at
    )
    VALUES (
        'paul@basicwelding.co.uk',
        crypt('password123', gen_salt('bf')), -- Simple password: password123
        now(),
        jsonb_build_object(
            'role', 'admin',
            'company_name', 'BWS LTD'
        ),
        now(),
        now(),
        'authenticated',
        (SELECT id FROM auth.instances LIMIT 1),
        now()
    )
    RETURNING id INTO admin_id;

    -- Create matching profile
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
    );

    -- Verify creation
    IF NOT EXISTS (
        SELECT 1 FROM auth.users 
        WHERE email = 'paul@basicwelding.co.uk' 
        AND confirmed_at IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Failed to create admin user';
    END IF;
END $$;

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT ON profiles TO anon;
GRANT ALL ON profiles TO authenticated; 