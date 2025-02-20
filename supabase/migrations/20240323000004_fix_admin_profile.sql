-- First, ensure the user exists in auth.users
DO $$
DECLARE
    user_id uuid;
BEGIN
    -- Get the user ID
    SELECT id INTO user_id FROM auth.users WHERE email = 'paul@basicwelding.co.uk';
    
    IF user_id IS NOT NULL THEN
        -- Delete any existing profile for this user
        DELETE FROM profiles WHERE id = user_id;
        
        -- Create a fresh profile with admin role
        INSERT INTO profiles (
            id,
            email,
            company_name,
            role,
            created_at,
            updated_at
        ) VALUES (
            user_id,
            'paul@basicwelding.co.uk',
            'BWS LTD',
            'admin',
            NOW(),
            NOW()
        );
        
        -- Set metadata in auth.users
        UPDATE auth.users 
        SET raw_user_meta_data = jsonb_build_object(
            'role', 'admin',
            'company_name', 'BWS LTD'
        )
        WHERE id = user_id;
    END IF;
END $$; 