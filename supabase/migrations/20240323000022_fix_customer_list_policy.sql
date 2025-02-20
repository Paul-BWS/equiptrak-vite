-- Drop existing policies
DROP POLICY IF EXISTS "allow_profile_access" ON profiles;

-- Create separate policies for different operations
CREATE POLICY "allow_select_for_admin" ON profiles
FOR SELECT USING (
    -- Direct admin email check
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
);

CREATE POLICY "allow_select_own_profile" ON profiles
FOR SELECT USING (
    -- Users can see their own profile
    id = auth.uid()
);

-- Ensure admin user exists with correct role
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'paul@basicwelding.co.uk';

-- Add some test data if none exists
INSERT INTO profiles (id, email, company_name, role, contact_name)
SELECT 
    gen_random_uuid(),
    'customer1@example.com',
    'Test Company 1',
    'customer',
    'Test User 1'
WHERE NOT EXISTS (
    SELECT 1 FROM profiles WHERE role = 'customer'
); 