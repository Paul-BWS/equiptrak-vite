-- Drop existing policies
DROP POLICY IF EXISTS "admin_full_access" ON profiles;
DROP POLICY IF EXISTS "users_own_profile" ON profiles;
DROP POLICY IF EXISTS "allow_profile_creation" ON profiles;

-- Temporarily disable RLS
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Create new policies
-- Allow admins full access to all profiles
CREATE POLICY "admin_full_access" ON profiles
FOR ALL USING (
    -- Check if user is admin by email
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Or check if user has admin role in their profile
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

-- Ensure admin exists and has correct role
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'paul@basicwelding.co.uk';

-- Grant admin role to sales@basicwelding.co.uk if exists
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'sales@basicwelding.co.uk'; 