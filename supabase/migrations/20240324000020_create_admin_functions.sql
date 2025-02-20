-- Drop any existing policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create a simple policy that handles both admin and user access
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (
    -- Admins (paul@basicwelding.co.uk and sales@basicwelding.co.uk) can do everything
    (email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk') OR
     contact_email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk'))
    OR
    -- Users can only access their own profile
    auth.uid() = id
);

-- Ensure admin roles are set correctly
UPDATE profiles 
SET role = 'admin' 
WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
   OR contact_email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk'); 