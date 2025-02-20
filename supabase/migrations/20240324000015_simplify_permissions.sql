-- Drop all existing policies
DROP POLICY IF EXISTS "enable_self_access" ON profiles;
DROP POLICY IF EXISTS "enable_profile_creation" ON profiles;
DROP POLICY IF EXISTS "admin_access" ON profiles;
DROP POLICY IF EXISTS "self_access" ON profiles;
DROP POLICY IF EXISTS "enable_profiles_access" ON profiles;
DROP POLICY IF EXISTS "admin_full_access" ON profiles;
DROP POLICY IF EXISTS "users_own_profile" ON profiles;
DROP POLICY IF EXISTS "allow_profile_creation" ON profiles;

-- Disable RLS completely since access control is handled at the application level
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Drop existing triggers
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS handle_new_user();

-- Create a simplified trigger function for user creation
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO profiles (
        id,
        email,
        company_name,
        role,
        telephone,
        mobile,
        address,
        city,
        county,
        postcode,
        country,
        contact_name,
        contact_email,
        stored_password
    ) VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'company_name', ''),
        CASE 
            WHEN NEW.email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk') THEN 'admin'
            ELSE 'customer'
        END,
        COALESCE(NEW.raw_user_meta_data->>'telephone', ''),
        COALESCE(NEW.raw_user_meta_data->>'mobile', ''),
        COALESCE(NEW.raw_user_meta_data->>'address', ''),
        COALESCE(NEW.raw_user_meta_data->>'city', ''),
        COALESCE(NEW.raw_user_meta_data->>'county', ''),
        COALESCE(NEW.raw_user_meta_data->>'postcode', ''),
        COALESCE(NEW.raw_user_meta_data->>'country', ''),
        COALESCE(NEW.raw_user_meta_data->>'contact_name', NEW.raw_user_meta_data->>'full_name', ''),
        COALESCE(NEW.raw_user_meta_data->>'contact_email', NEW.email),
        NEW.raw_user_meta_data->>'password'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create new trigger
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION handle_new_user();

-- Ensure admin roles are set correctly
UPDATE profiles 
SET role = 'admin' 
WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk'); 