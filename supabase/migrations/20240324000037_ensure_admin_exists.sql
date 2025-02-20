-- Ensure the admin user exists in auth.users
DO $$
DECLARE
    admin_id uuid;
BEGIN
    -- First try to get existing admin ID
    SELECT id INTO admin_id 
    FROM auth.users 
    WHERE email = 'paul@basicwelding.co.uk';

    -- If admin doesn't exist, create them
    IF admin_id IS NULL THEN
        INSERT INTO auth.users (
            email,
            encrypted_password,
            email_confirmed_at,
            raw_user_meta_data,
            created_at,
            updated_at,
            role
        )
        VALUES (
            'paul@basicwelding.co.uk',
            crypt('admin123', gen_salt('bf')), -- You'll need to change this password
            now(),
            jsonb_build_object(
                'role', 'admin',
                'company_name', 'BWS LTD'
            ),
            now(),
            now(),
            'authenticated'
        )
        RETURNING id INTO admin_id;
    END IF;

    -- Now ensure the profile exists
    INSERT INTO public.profiles (
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

    -- Verify the profile was created
    IF NOT EXISTS (
        SELECT 1 FROM profiles 
        WHERE email = 'paul@basicwelding.co.uk' 
        AND role = 'admin'
    ) THEN
        RAISE EXCEPTION 'Failed to create admin profile';
    END IF;
END $$;

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT ON profiles TO anon;
GRANT ALL ON profiles TO authenticated;

-- Create a simple policy that allows reading profiles
DROP POLICY IF EXISTS "allow_all_profiles_access" ON profiles;
CREATE POLICY "profiles_read_policy" ON profiles
FOR SELECT USING (true);

-- Create a policy for modifying profiles
CREATE POLICY "profiles_modify_policy" ON profiles
FOR ALL USING (
    auth.uid() = id
    OR 
    auth.jwt() ->> 'email' = 'paul@basicwelding.co.uk'
); 