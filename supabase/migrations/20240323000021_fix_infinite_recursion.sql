-- Drop all existing policies
DROP POLICY IF EXISTS "profiles_access" ON profiles;
DROP POLICY IF EXISTS "admin_view_all_profiles" ON profiles;
DROP POLICY IF EXISTS "users_view_own_profile" ON profiles;

-- Create a simple, non-recursive policy
CREATE POLICY "allow_profile_access" ON profiles
FOR ALL USING (
    -- Allow access to own profile
    id = auth.uid()
    OR 
    -- Allow access if user is admin (direct email check)
    auth.jwt() ->> 'email' = 'paul@basicwelding.co.uk'
    OR 
    auth.jwt() ->> 'email' = 'sales@basicwelding.co.uk'
);

-- Ensure admin user exists with correct role
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