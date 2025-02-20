-- First, drop the problematic policy
DROP POLICY IF EXISTS "Users can view their own company profiles" ON profiles;

-- Create a new, non-recursive policy
CREATE POLICY "company_and_admin_access" ON profiles
FOR SELECT USING (
    -- Get the current user's profile in a CTE to avoid recursion
    WITH user_profile AS (
        SELECT role, company_name 
        FROM profiles 
        WHERE id = auth.uid()
    )
    -- Use the CTE result for policy checks
    EXISTS (
        SELECT 1 FROM user_profile
        WHERE 
            -- User is an admin
            role = 'admin'
            OR
            -- Or user is viewing their own company's profiles
            (company_name IS NOT NULL AND company_name = profiles.company_name)
    )
); 