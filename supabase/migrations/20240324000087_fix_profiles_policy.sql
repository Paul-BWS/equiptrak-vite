-- Drop existing policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;

-- Create a simple policy for profiles
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (
  auth.uid() = id OR 
  EXISTS (
    SELECT 1 FROM auth.users 
    WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    AND auth.uid() = auth.users.id
  )
); 