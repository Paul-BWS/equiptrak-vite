-- Drop existing policies
DROP POLICY IF EXISTS "profiles_read_policy" ON profiles;
DROP POLICY IF EXISTS "profiles_write_policy" ON profiles;

-- Create a more permissive read policy for profiles
CREATE POLICY "profiles_read_policy" ON profiles
FOR SELECT USING (
    -- Everyone can read their own profile
    auth.uid() = id
    OR
    -- Admins can read all profiles
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND role = 'admin'
    )
);

-- Create a write policy for profiles
CREATE POLICY "profiles_write_policy" ON profiles
FOR UPDATE USING (
    -- Users can update their own profile
    auth.uid() = id
    OR
    -- Admins can update any profile
    EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = auth.uid() 
        AND role = 'admin'
    )
);

-- Ensure permissions are granted
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT, UPDATE ON profiles TO authenticated;

-- Ensure admin roles are set correctly
UPDATE profiles 
SET role = 'admin' 
WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk'); 