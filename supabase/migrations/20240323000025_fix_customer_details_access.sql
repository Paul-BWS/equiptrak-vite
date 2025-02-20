-- Drop the overly restrictive policy
DROP POLICY IF EXISTS "basic_access" ON profiles;

-- Create a comprehensive policy for profiles
CREATE POLICY "profiles_access_policy" ON profiles
FOR ALL USING (
    -- User can access their own profile
    id = auth.uid()
    OR
    -- Admin can access all profiles (using direct email check)
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Admin can access all profiles (using role check)
    EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid()
        AND role = 'admin'
    )
); 