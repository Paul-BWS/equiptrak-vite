-- Drop all existing policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;
DROP POLICY IF EXISTS "equipment_policy" ON equipment;
DROP POLICY IF EXISTS "profiles_read_policy" ON profiles;
DROP POLICY IF EXISTS "profiles_write_policy" ON profiles;
DROP POLICY IF EXISTS "equipment_read_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_write_policy" ON equipment;

-- Enable RLS on tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;

-- Create read-only policy for profiles
CREATE POLICY "profiles_read_policy" ON profiles
FOR SELECT USING (
    -- Admins can read all
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can read their own profile
    auth.uid() = id
);

-- Create write policy for profiles (admin only)
CREATE POLICY "profiles_write_policy" ON profiles
FOR ALL USING (
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
);

-- Create read-only policy for equipment
CREATE POLICY "equipment_read_policy" ON equipment
FOR SELECT USING (
    -- Admins can read all
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can read their own equipment
    customer_id = auth.uid()
);

-- Create write policy for equipment (admin only)
CREATE POLICY "equipment_write_policy" ON equipment
FOR ALL USING (
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
);

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT ON profiles TO authenticated;
GRANT SELECT ON equipment TO authenticated;

-- Revoke all permissions from anon
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM anon;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM anon;
REVOKE ALL ON ALL ROUTINES IN SCHEMA public FROM anon;

-- Grant admin users full access
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- Ensure admin roles are set correctly
UPDATE profiles 
SET role = 'admin' 
WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk'); 