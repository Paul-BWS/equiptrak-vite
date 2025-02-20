-- Drop existing policies
DROP POLICY IF EXISTS "enable_self_access" ON profiles;
DROP POLICY IF EXISTS "enable_profile_creation" ON profiles;
DROP POLICY IF EXISTS "admin_access" ON profiles;
DROP POLICY IF EXISTS "self_access" ON profiles;
DROP POLICY IF EXISTS "enable_profiles_access" ON profiles;
DROP POLICY IF EXISTS "admin_full_access" ON profiles;
DROP POLICY IF EXISTS "users_own_profile" ON profiles;
DROP POLICY IF EXISTS "allow_profile_creation" ON profiles;

-- Disable RLS completely for now
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Grant necessary permissions to authenticated and anon roles
GRANT ALL ON profiles TO authenticated;
GRANT ALL ON profiles TO anon;
GRANT ALL ON auth.users TO authenticated;
GRANT ALL ON auth.users TO anon;

-- Ensure admin roles are set correctly
UPDATE profiles 
SET role = 'admin' 
WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk'); 