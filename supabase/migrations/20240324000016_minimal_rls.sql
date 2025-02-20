-- Drop all existing policies first
DROP POLICY IF EXISTS "enable_self_access" ON profiles;
DROP POLICY IF EXISTS "enable_profile_creation" ON profiles;
DROP POLICY IF EXISTS "admin_access" ON profiles;
DROP POLICY IF EXISTS "self_access" ON profiles;
DROP POLICY IF EXISTS "enable_profiles_access" ON profiles;
DROP POLICY IF EXISTS "admin_full_access" ON profiles;
DROP POLICY IF EXISTS "users_own_profile" ON profiles;
DROP POLICY IF EXISTS "allow_profile_creation" ON profiles;

-- Enable RLS on tables (not views)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;

-- Simple policy for profiles: admins can do everything, users can read all but only update their own
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

-- Simple policy for equipment: admins can do everything, users can only view their own
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