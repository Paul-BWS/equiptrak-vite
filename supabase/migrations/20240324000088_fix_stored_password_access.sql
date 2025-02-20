-- Drop any existing password-related policies
DROP POLICY IF EXISTS "admins_password_access" ON profiles;

-- Create policy for stored password access
CREATE POLICY "admins_password_access" ON profiles
FOR SELECT
USING (
    -- Allow access for BWS admin emails directly
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
);

-- Ensure RLS is enabled
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Grant necessary permissions
GRANT SELECT (stored_password) ON profiles TO authenticated; 