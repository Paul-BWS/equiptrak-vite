-- Drop existing policies
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view profiles in their company" ON profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;

-- Create new, simpler policies
CREATE POLICY "Enable read access for all users"
    ON profiles FOR SELECT
    USING (true);

CREATE POLICY "Enable update for users based on email"
    ON profiles FOR UPDATE
    USING (auth.jwt() ->> 'email' = email);

-- Ensure your profile exists with admin role
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