-- Temporarily disable RLS
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "profiles_access_policy" ON profiles;
DROP POLICY IF EXISTS "basic_access" ON profiles;

-- Create a view for admin check
CREATE OR REPLACE VIEW admin_users AS
SELECT id
FROM profiles
WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
   OR role = 'admin';

-- Grant access to the view
GRANT SELECT ON admin_users TO authenticated;

-- Create a simple non-recursive policy
CREATE POLICY "allow_profile_access" ON profiles
FOR ALL USING (
    -- Allow access to own profile
    id = auth.uid()
    OR 
    -- Allow access if user is in admin_users view
    auth.uid() IN (SELECT id FROM admin_users)
);

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Ensure admin user exists
DO $$
BEGIN
    UPDATE profiles 
    SET role = 'admin' 
    WHERE email = 'paul@basicwelding.co.uk';

    -- Add a test customer if none exist
    INSERT INTO profiles (id, email, company_name, role, contact_name)
    SELECT 
        gen_random_uuid(),
        'test@example.com',
        'Test Company',
        'customer',
        'Test User'
    WHERE NOT EXISTS (
        SELECT 1 FROM profiles WHERE role = 'customer'
    );
END $$; 