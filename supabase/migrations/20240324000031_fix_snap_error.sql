-- Drop existing policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;
DROP POLICY IF EXISTS "equipment_policy" ON equipment;
DROP POLICY IF EXISTS "companies_policy" ON companies;

-- Create a more permissive policy for profiles
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (
    -- Admins can do everything (check both email and role)
    (auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid()
        AND role = 'admin'
    ))
    OR
    -- Users can read all profiles
    (LOWER(current_setting('request.method', true)) = 'get')
    OR
    -- Users can modify their own profile
    auth.uid() = id
);

-- Simple policy for equipment
CREATE POLICY "equipment_policy" ON equipment
FOR ALL USING (
    -- Admins can do everything (check both email and role)
    (auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid()
        AND role = 'admin'
    ))
    OR
    -- Users can only see their own equipment
    customer_id = auth.uid()
);

-- Create a simpler, non-recursive policy for companies
CREATE POLICY "companies_access_policy" ON companies
FOR ALL USING (
    -- Direct check for admin emails
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Allow all authenticated users to read companies
    (
        auth.role() = 'authenticated' 
        AND 
        current_setting('request.method', true) = 'GET'
    )
);

-- Ensure admin roles are set correctly
UPDATE profiles 
SET role = 'admin' 
WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk');

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT ALL ON companies TO authenticated;

-- Refresh admin permissions
DO $$
BEGIN
    -- Ensure admin can access everything
    PERFORM set_config('request.jwt.claims', 
        json_build_object(
            'role', 'authenticated',
            'email', 'paul@basicwelding.co.uk'
        )::text,
        true
    );
END $$; 