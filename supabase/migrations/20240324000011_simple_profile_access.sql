-- Drop all existing policies
DROP POLICY IF EXISTS "admin_access" ON profiles;
DROP POLICY IF EXISTS "self_access" ON profiles;
DROP POLICY IF EXISTS "enable_profiles_access" ON profiles;
DROP POLICY IF EXISTS "admin_full_access" ON profiles;
DROP POLICY IF EXISTS "users_own_profile" ON profiles;
DROP POLICY IF EXISTS "allow_profile_creation" ON profiles;

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create simple policy for self-access
CREATE POLICY "enable_self_access" ON profiles
FOR ALL
USING (
    auth.uid() = id
);

-- Allow profile creation during signup
CREATE POLICY "enable_profile_creation" ON profiles
FOR INSERT
WITH CHECK (true); 