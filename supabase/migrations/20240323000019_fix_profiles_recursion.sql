-- Drop all existing profile policies
DROP POLICY IF EXISTS "Users can view their own company profiles" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;
DROP POLICY IF EXISTS "company_and_admin_access" ON profiles;

-- Create a simple non-recursive policy for profiles
CREATE POLICY "profiles_access" ON profiles
FOR ALL USING (
    -- Direct check against user's own profile
    id = auth.uid()
    OR
    -- Direct check for admin email
    auth.jwt() ->> 'email' = 'paul@basicwelding.co.uk'
    OR
    auth.jwt() ->> 'email' = 'sales@basicwelding.co.uk'
    OR
    -- Or same company as user
    company_name = (
        SELECT company_name 
        FROM profiles 
        WHERE id = auth.uid() 
        LIMIT 1
    )
); 