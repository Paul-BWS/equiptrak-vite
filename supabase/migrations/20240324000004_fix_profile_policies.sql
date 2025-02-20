-- First, disable RLS temporarily to make changes
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "admin_full_access" ON profiles;
DROP POLICY IF EXISTS "users_own_profile" ON profiles;
DROP POLICY IF EXISTS "allow_profile_creation" ON profiles;

-- Create new policies
-- Allow admins full access
CREATE POLICY "admin_full_access" ON profiles
FOR ALL USING (
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid()
        AND role = 'admin'
    )
);

-- Allow users to access their own profile
CREATE POLICY "users_own_profile" ON profiles
FOR ALL USING (
    id = auth.uid()
);

-- Allow profile creation during signup
CREATE POLICY "allow_profile_creation" ON profiles
FOR INSERT WITH CHECK (true);

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Ensure admin exists
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'paul@basicwelding.co.uk'; 