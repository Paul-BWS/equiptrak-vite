-- Drop existing policies
DROP POLICY IF EXISTS "Enable read access for all users" ON profiles;
DROP POLICY IF EXISTS "Enable update for users based on email" ON profiles;

-- Create more secure policies
CREATE POLICY "Users can view their own company profiles"
    ON profiles FOR SELECT
    USING (
        company_name IN (
            SELECT company_name FROM profiles WHERE id = auth.uid()
        )
        OR role = 'admin'
    );

CREATE POLICY "Users can update their own profile"
    ON profiles FOR UPDATE
    USING (id = auth.uid());

CREATE POLICY "Admins can update any profile"
    ON profiles FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE id = auth.uid()
            AND role = 'admin'
        )
    );

-- Ensure BWS admin exists
DO $$
DECLARE
    v_user_id uuid;
BEGIN
    SELECT id INTO v_user_id FROM auth.users WHERE email = 'paul@basicwelding.co.uk';
    
    IF v_user_id IS NOT NULL THEN
        INSERT INTO profiles (id, email, company_name, role)
        VALUES (v_user_id, 'paul@basicwelding.co.uk', 'BWS LTD', 'admin'::user_role)
        ON CONFLICT (id) DO UPDATE
        SET role = 'admin'::user_role,
            company_name = 'BWS LTD';
    END IF;
END $$; 