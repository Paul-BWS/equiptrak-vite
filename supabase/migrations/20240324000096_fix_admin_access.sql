-- Drop existing policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;

-- Create a policy that allows access to:
-- 1. Users accessing their own profile (auth.uid() = id)
-- 2. Any user with admin role in their JWT
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (
  auth.uid() = id OR 
  auth.jwt() ->> 'role' = 'admin'
);

-- Re-grant necessary permissions
GRANT USAGE ON SEQUENCE certificate_number_seq TO authenticated;
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO authenticated; 