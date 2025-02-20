-- Drop all recent policies and views
DROP POLICY IF EXISTS "profiles_read_policy" ON profiles;
DROP POLICY IF EXISTS "profiles_write_policy" ON profiles;
DROP VIEW IF EXISTS customer_list;

-- Restore the simple working policies
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (
    -- Admins can do everything
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can read all profiles
    current_setting('request.method', true) = 'GET'
    OR
    -- Users can only modify their own profile
    auth.uid() = id
);

-- Simple policy for equipment
CREATE POLICY "equipment_policy" ON equipment
FOR ALL USING (
    -- Admins can do everything
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can only see their own equipment
    customer_id = auth.uid()
);

-- Ensure admin roles are set
UPDATE profiles 
SET role = 'admin' 
WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk'); 