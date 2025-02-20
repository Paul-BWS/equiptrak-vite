-- First, disable RLS
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Clean up existing admin entries
DO $$
BEGIN
    -- Delete existing entries
    DELETE FROM auth.users WHERE email = 'paul@basicwelding.co.uk';
    DELETE FROM profiles WHERE email = 'paul@basicwelding.co.uk';
END $$;

-- Create the admin user with a very simple password
DO $$
DECLARE
    admin_id uuid;
BEGIN
    -- Insert into auth.users with raw password (will be hashed by Supabase)
    INSERT INTO auth.users (
        instance_id,
        id,
        aud,
        role,
        email,
        raw_user_meta_data,
        raw_app_meta_data,
        is_super_admin,
        encrypted_password,
        created_at,
        updated_at,
        confirmed_at,
        last_sign_in_at,
        confirmation_sent_at
    )
    VALUES (
        (SELECT id FROM auth.instances LIMIT 1),
        gen_random_uuid(),
        'authenticated',
        'authenticated',
        'paul@basicwelding.co.uk',
        '{"role": "admin"}'::jsonb,
        '{"provider": "email"}'::jsonb,
        FALSE,
        -- Using a very simple password: Admin123
        crypt('Admin123', gen_salt('bf')),
        now(),
        now(),
        now(),
        now(),
        now()
    )
    RETURNING id INTO admin_id;

    -- Create the profile
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

    -- Verify the user was created
    IF NOT EXISTS (
        SELECT 1 FROM auth.users 
        WHERE email = 'paul@basicwelding.co.uk' 
        AND encrypted_password IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Failed to create admin user';
    END IF;
END $$;

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create a simple policy for profiles
DROP POLICY IF EXISTS "profiles_policy" ON profiles;
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (true)
WITH CHECK (true);

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON profiles TO anon;
GRANT ALL ON profiles TO authenticated;

-- Verify final setup
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM auth.users u
        JOIN profiles p ON u.id = p.id
        WHERE u.email = 'paul@basicwelding.co.uk'
        AND p.role = 'admin'
        AND u.confirmed_at IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Admin user verification failed';
    END IF;
END $$; 