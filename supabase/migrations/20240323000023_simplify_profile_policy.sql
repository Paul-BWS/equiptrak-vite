-- First, disable RLS temporarily to ensure we can update data
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Drop all existing policies
DROP POLICY IF EXISTS "allow_profile_access" ON profiles;
DROP POLICY IF EXISTS "allow_select_for_admin" ON profiles;
DROP POLICY IF EXISTS "allow_select_own_profile" ON profiles;

-- Update admin user
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'paul@basicwelding.co.uk';

-- Add test customer if none exist
INSERT INTO profiles (id, email, company_name, role, contact_name)
SELECT 
    gen_random_uuid(),
    'customer1@example.com',
    'Test Company 1',
    'customer',
    'Test User 1'
WHERE NOT EXISTS (
    SELECT 1 FROM profiles WHERE role = 'customer'
);

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create a single, simple policy
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (
    -- Either the user is accessing their own profile
    id = auth.uid()
    OR
    -- Or the user is an admin (based on email)
    auth.jwt() ->> 'email' = 'paul@basicwelding.co.uk'
    OR
    auth.jwt() ->> 'email' = 'sales@basicwelding.co.uk'
); 