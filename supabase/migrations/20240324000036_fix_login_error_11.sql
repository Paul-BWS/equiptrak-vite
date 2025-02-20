-- First, disable RLS temporarily
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;

-- Grant basic permissions
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT, INSERT, UPDATE ON profiles TO anon;
GRANT ALL ON profiles TO authenticated;

-- Create the simplest possible policy for profiles
CREATE POLICY "allow_all_profiles_access" ON profiles
FOR ALL USING (true)
WITH CHECK (true);

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Ensure admin exists
DO $$
DECLARE
    admin_id uuid;
BEGIN
    -- Get the admin user ID
    SELECT id INTO admin_id FROM auth.users WHERE email = 'paul@basicwelding.co.uk';
    
    IF admin_id IS NOT NULL THEN
        -- Ensure admin profile exists
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