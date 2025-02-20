-- First, drop all existing policies to start fresh
DROP POLICY IF EXISTS "Users can view their own company profiles" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
DROP POLICY IF EXISTS "Admins can update any profile" ON profiles;
DROP POLICY IF EXISTS "Enable read access for all users" ON profiles;
DROP POLICY IF EXISTS "Enable update for users based on email" ON profiles;

-- Create a single, simple read policy
CREATE POLICY "profiles_select_policy" ON profiles
FOR SELECT USING (
    -- Allow admin access
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
    OR
    -- Allow users to see their own profile
    id = auth.uid()
);

-- Create a simple update policy
CREATE POLICY "profiles_update_policy" ON profiles
FOR UPDATE USING (
    -- Allow admin access
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'admin'
    OR
    -- Allow users to update their own profile
    id = auth.uid()
);

-- Ensure the admin user exists and has the correct role
DO $$
DECLARE
    admin_id uuid;
BEGIN
    -- Get the admin user ID
    SELECT id INTO admin_id FROM auth.users WHERE email = 'paul@basicwelding.co.uk';
    
    IF admin_id IS NOT NULL THEN
        -- Update or insert the admin profile
        INSERT INTO profiles (
            id,
            email,
            company_name,
            role,
            created_at,
            updated_at
        ) VALUES (
            admin_id,
            'paul@basicwelding.co.uk',
            'BWS LTD',
            'admin',
            NOW(),
            NOW()
        )
        ON CONFLICT (id) DO UPDATE
        SET role = 'admin',
            company_name = 'BWS LTD',
            updated_at = NOW();
            
        -- Update auth.users metadata
        UPDATE auth.users 
        SET raw_user_meta_data = jsonb_build_object(
            'role', 'admin',
            'company_name', 'BWS LTD'
        )
        WHERE id = admin_id;
    END IF;
END $$; 