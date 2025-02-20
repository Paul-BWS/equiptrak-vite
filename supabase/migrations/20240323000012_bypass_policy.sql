-- Drop all existing policies
DROP POLICY IF EXISTS "Users can view their own company profiles" ON profiles;
DROP POLICY IF EXISTS "company_and_admin_access" ON profiles;
DROP POLICY IF EXISTS "allow_admin_and_company_access" ON profiles;

-- Create a simple policy that just allows the query
CREATE POLICY "temp_allow_select" ON profiles
FOR SELECT USING (true); 