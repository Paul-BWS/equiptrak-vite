-- First, disable RLS temporarily
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Drop all existing policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;
DROP POLICY IF EXISTS "allow_profile_access" ON profiles;
DROP POLICY IF EXISTS "allow_select_for_admin" ON profiles;
DROP POLICY IF EXISTS "allow_select_own_profile" ON profiles;

-- Create a view for customers
CREATE OR REPLACE VIEW customer_list AS
SELECT 
    id,
    email,
    company_name,
    address,
    city,
    postcode,
    telephone,
    role,
    contact_name,
    created_at,
    updated_at
FROM profiles
WHERE role = 'customer'
AND email NOT IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk');

-- Grant access to authenticated users
GRANT SELECT ON customer_list TO authenticated;

-- Re-enable RLS with a simple policy
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create a simple policy for profiles
CREATE POLICY "basic_access" ON profiles
FOR ALL USING (
    id = auth.uid()
);

-- Ensure admin exists
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'paul@basicwelding.co.uk';

-- Add test data if needed
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