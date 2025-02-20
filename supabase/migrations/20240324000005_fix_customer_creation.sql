-- First, ensure the user_role type exists
DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('admin', 'customer');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Drop existing policies
DROP POLICY IF EXISTS "admin_full_access" ON profiles;
DROP POLICY IF EXISTS "users_own_profile" ON profiles;
DROP POLICY IF EXISTS "allow_profile_creation" ON profiles;
DROP POLICY IF EXISTS "basic_access" ON profiles;

-- Temporarily disable RLS
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Create new policies
-- Allow admins full access
CREATE POLICY "admin_full_access" ON profiles
FOR ALL USING (
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
);

-- Allow users to access their own profile
CREATE POLICY "users_own_profile" ON profiles
FOR ALL USING (
    id = auth.uid()
);

-- Allow profile creation during signup
CREATE POLICY "allow_profile_creation" ON profiles
FOR INSERT WITH CHECK (true);

-- Create a trigger function to handle user creation
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO profiles (
        id,
        email,
        company_name,
        role,
        contact_name
    ) VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'company_name', ''),
        (CASE 
            WHEN NEW.email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk') THEN 'admin'
            ELSE 'customer'
        END)::user_role,
        COALESCE(NEW.raw_user_meta_data->>'full_name', '')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Create trigger for new user creation
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION handle_new_user();

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Ensure admin exists
UPDATE profiles 
SET role = 'admin'::user_role 
WHERE email = 'paul@basicwelding.co.uk'; 