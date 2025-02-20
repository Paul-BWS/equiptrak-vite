-- First, drop the overly permissive policies
DROP POLICY IF EXISTS "profiles_select_policy" ON profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON profiles;

-- Create secure company-based policies
CREATE POLICY "Users can view their own company profiles"
    ON profiles FOR SELECT
    USING (
        -- Users can only see profiles from their own company
        EXISTS (
            SELECT 1 FROM profiles p
            WHERE p.id = auth.uid()
            AND (
                -- Either they are in the same company
                p.company_name = profiles.company_name
                OR
                -- Or they are an admin
                p.role = 'admin'
            )
        )
    );

-- Secure update policy
CREATE POLICY "Users can update their own profile"
    ON profiles FOR UPDATE
    USING (
        -- Users can only update their own profile
        id = auth.uid()
        OR
        -- Or they are an admin
        EXISTS (
            SELECT 1 FROM profiles p
            WHERE p.id = auth.uid()
            AND p.role = 'admin'
        )
    );

-- Ensure admin status for BWS users
DO $$
DECLARE
    v_user_id uuid;
BEGIN
    -- Update paul@basicwelding.co.uk
    SELECT id INTO v_user_id FROM auth.users WHERE email = 'paul@basicwelding.co.uk';
    IF v_user_id IS NOT NULL THEN
        INSERT INTO profiles (id, email, company_name, role)
        VALUES (v_user_id, 'paul@basicwelding.co.uk', 'BWS LTD', 'admin')
        ON CONFLICT (id) DO UPDATE
        SET role = 'admin',
            company_name = 'BWS LTD';
    END IF;

    -- Update sales@basicwelding.co.uk if exists
    SELECT id INTO v_user_id FROM auth.users WHERE email = 'sales@basicwelding.co.uk';
    IF v_user_id IS NOT NULL THEN
        INSERT INTO profiles (id, email, company_name, role)
        VALUES (v_user_id, 'sales@basicwelding.co.uk', 'BWS LTD', 'admin')
        ON CONFLICT (id) DO UPDATE
        SET role = 'admin',
            company_name = 'BWS LTD';
    END IF;
END $$; 