-- Add password field to profiles table
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS stored_password TEXT;

-- Add comment to explain the field's purpose
COMMENT ON COLUMN profiles.stored_password IS 'Stores the generated password for reference by admins';

-- Ensure RLS is enabled
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Drop existing password policy if exists
DROP POLICY IF EXISTS "admins_view_password" ON profiles;

-- Create policy for admin access to password field
CREATE POLICY "admins_password_access" ON profiles
FOR ALL
USING (
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
)
WITH CHECK (
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
); 