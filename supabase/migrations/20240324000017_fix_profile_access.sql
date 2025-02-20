-- Drop existing policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;
DROP POLICY IF EXISTS "equipment_policy" ON equipment;

-- Create new policy that properly handles profile access
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (
    -- Admins can do everything
    (auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk'))
    OR
    -- Users can read all profiles if they are authenticated
    (
        current_setting('request.method', true) = 'GET' 
        AND 
        auth.role() = 'authenticated'
    )
    OR
    -- Users can modify their own profile
    (auth.uid() = id)
);

-- Create equipment policy
CREATE POLICY "equipment_policy" ON equipment
FOR ALL USING (
    -- Admins can do everything
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can only see their own equipment
    customer_id = auth.uid()
);

-- Ensure views have proper access
GRANT SELECT ON customer_list TO authenticated;
GRANT SELECT ON equipment_details TO authenticated; 