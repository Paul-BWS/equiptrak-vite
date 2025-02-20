-- Create or replace the function to handle new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (
        id,
        email,
        role,
        company_name
    )
    VALUES (
        NEW.id,
        NEW.email,
        CASE 
            WHEN NEW.email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk') THEN 'admin'
            ELSE 'customer'
        END,
        COALESCE(NEW.raw_user_meta_data->>'company_name', 'BWS LTD')
    )
    ON CONFLICT (id) DO UPDATE
    SET 
        email = EXCLUDED.email,
        role = CASE 
            WHEN EXCLUDED.email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk') THEN 'admin'
            ELSE 'customer'
        END,
        company_name = COALESCE(NEW.raw_user_meta_data->>'company_name', 'BWS LTD'),
        updated_at = now();
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop if exists and recreate trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- Ensure all existing users have profiles
INSERT INTO profiles (id, email, role, company_name)
SELECT 
    id,
    email,
    CASE 
        WHEN email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk') THEN 'admin'
        ELSE 'customer'
    END as role,
    COALESCE(raw_user_meta_data->>'company_name', 'BWS LTD') as company_name
FROM auth.users
ON CONFLICT (id) DO UPDATE
SET 
    email = EXCLUDED.email,
    role = CASE 
        WHEN EXCLUDED.email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk') THEN 'admin'
        ELSE 'customer'
    END,
    company_name = EXCLUDED.company_name,
    updated_at = now(); 