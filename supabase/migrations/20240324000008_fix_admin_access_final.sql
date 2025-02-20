-- Drop existing policies
DROP POLICY IF EXISTS "admin_full_access" ON profiles;
DROP POLICY IF EXISTS "users_own_profile" ON profiles;
DROP POLICY IF EXISTS "allow_profile_creation" ON profiles;
DROP POLICY IF EXISTS "admins_password_access" ON profiles;

-- Temporarily disable RLS
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Create a single comprehensive policy for all operations
CREATE POLICY "enable_profiles_access" ON profiles
FOR ALL
USING (
    -- User can access their own profile
    id = auth.uid()
    OR
    -- Admin access (by email)
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
);

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Ensure admin role is set correctly
UPDATE profiles 
SET role = 'admin' 
WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk'); 