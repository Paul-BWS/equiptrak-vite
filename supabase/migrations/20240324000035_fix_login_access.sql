-- First, temporarily disable RLS to ensure we can fix things
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE companies DISABLE ROW LEVEL SECURITY;
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;

-- Drop all existing policies to start fresh
DROP POLICY IF EXISTS "profiles_policy" ON profiles;
DROP POLICY IF EXISTS "equipment_policy" ON equipment;
DROP POLICY IF EXISTS "companies_policy" ON companies;
DROP POLICY IF EXISTS "companies_access_policy" ON companies;

-- Grant necessary permissions to public and authenticated roles
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;

-- Grant specific table permissions
GRANT SELECT ON profiles TO anon;
GRANT SELECT ON profiles TO authenticated;
GRANT ALL ON profiles TO authenticated;

GRANT SELECT ON companies TO anon;
GRANT SELECT ON companies TO authenticated;
GRANT ALL ON companies TO authenticated;

GRANT SELECT ON equipment TO authenticated;
GRANT ALL ON equipment TO authenticated;

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;

-- Create simple, non-recursive policies
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (
    -- Allow public read for login
    current_setting('request.method', true) = 'GET'
    OR
    -- Allow admin full access
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Allow users to modify their own profile
    auth.uid() = id
);

CREATE POLICY "companies_policy" ON companies
FOR ALL USING (
    -- Allow public read
    current_setting('request.method', true) = 'GET'
    OR
    -- Allow admin full access
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
);

CREATE POLICY "equipment_policy" ON equipment
FOR ALL USING (
    -- Admin full access
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can only see their own equipment
    customer_id = auth.uid()
);

-- Ensure admin roles are set
UPDATE profiles 
SET role = 'admin' 
WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk');

-- Reset the session claims
SELECT set_config('request.jwt.claims', '{"role": "anon"}', true); 