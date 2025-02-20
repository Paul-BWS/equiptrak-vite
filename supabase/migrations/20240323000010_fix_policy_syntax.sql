-- Drop the problematic policy
DROP POLICY IF EXISTS "Users can view their own company profiles" ON profiles;
DROP POLICY IF EXISTS "company_and_admin_access" ON profiles;

-- Create a simpler policy without CTE
CREATE POLICY "company_and_admin_access" ON profiles
FOR SELECT USING (
    -- Either the user is an admin
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
    OR
    -- Or they are viewing profiles from their own company
    (SELECT company_name FROM profiles WHERE id = auth.uid()) = company_name
); 