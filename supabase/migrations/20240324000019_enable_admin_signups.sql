-- Enable admin signups through service role
ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

-- Drop any existing policies
DROP POLICY IF EXISTS "enable_admin_signups" ON auth.users;

-- Create policy to allow service role to create users
CREATE POLICY "enable_admin_signups"
ON auth.users
FOR INSERT
TO service_role
WITH CHECK (true);

-- Ensure admin roles are properly set
CREATE OR REPLACE FUNCTION public.handle_new_admin_user()
RETURNS TRIGGER AS $$
BEGIN
    -- Set role to admin if created by an admin
    IF NEW.raw_user_meta_data->>'created_by' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk') THEN
        UPDATE auth.users
        SET raw_user_meta_data = 
            jsonb_set(
                COALESCE(raw_user_meta_data, '{}'::jsonb),
                '{role}',
                '"admin"'
            )
        WHERE id = NEW.id;
        
        -- Also update the profile
        UPDATE profiles
        SET role = 'admin'
        WHERE id = NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new admin users
DROP TRIGGER IF EXISTS on_admin_user_created ON auth.users;
CREATE TRIGGER on_admin_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_admin_user();

-- Grant necessary permissions
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON auth.users TO service_role; 