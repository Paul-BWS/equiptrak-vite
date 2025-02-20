-- Drop existing policies
DROP POLICY IF EXISTS "enable_profiles_access" ON profiles;
DROP POLICY IF EXISTS "admin_full_access" ON profiles;
DROP POLICY IF EXISTS "users_own_profile" ON profiles;
DROP POLICY IF EXISTS "allow_profile_creation" ON profiles;

-- Temporarily disable RLS
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Create a simple policy for admin access
CREATE POLICY "admin_access" ON profiles
FOR ALL
USING (
    -- Admin access by email
    auth.jwt() ->> 'email' = 'paul@basicwelding.co.uk' OR
    auth.jwt() ->> 'email' = 'sales@basicwelding.co.uk'
);

-- Create a policy for users to access their own profile
CREATE POLICY "self_access" ON profiles
FOR ALL
USING (
    auth.uid() = id
);

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Ensure admin roles are set correctly
UPDATE profiles 
SET role = 'admin' 
WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk'); 