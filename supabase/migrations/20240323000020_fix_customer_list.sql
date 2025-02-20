-- Drop existing policies
DROP POLICY IF EXISTS "profiles_access" ON profiles;

-- Create a simpler policy for admin access
CREATE POLICY "admin_view_all_profiles" ON profiles
FOR SELECT USING (
    -- Check if the user is an admin
    EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid()
        AND role = 'admin'
    )
);

-- Create policy for users to view their own profile
CREATE POLICY "users_view_own_profile" ON profiles
FOR SELECT USING (
    id = auth.uid()
);

-- Ensure admin user has correct role
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'paul@basicwelding.co.uk';

-- Add some test customers if none exist
INSERT INTO profiles (id, email, company_name, role, contact_name)
SELECT 
    gen_random_uuid(),
    'test1@example.com',
    'Test Company 1',
    'customer',
    'Test Contact 1'
WHERE NOT EXISTS (
    SELECT 1 FROM profiles 
    WHERE role = 'customer'
); 