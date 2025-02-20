-- Drop existing policies
DROP POLICY IF EXISTS "Users can view their own company profiles" ON profiles;
DROP POLICY IF EXISTS "company_and_admin_access" ON profiles;

-- Create a direct policy
CREATE POLICY "allow_admin_and_company_access" ON profiles
FOR SELECT USING (
    -- Direct check against auth.uid()
    id = auth.uid()
    OR
    -- Direct check if user is admin
    auth.uid() IN (
        SELECT id FROM profiles WHERE role = 'admin'
    )
); 