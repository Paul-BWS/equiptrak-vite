-- Get the user ID from auth.users if it exists
DO $$
DECLARE
    v_user_id uuid;
BEGIN
    -- Get the user ID if it exists
    SELECT id INTO v_user_id 
    FROM auth.users 
    WHERE email = 'paul@basicwelding.co.uk';

    -- If we found the user, ensure they have a profile
    IF v_user_id IS NOT NULL THEN
        -- Create or update profile
        INSERT INTO profiles (
            id,
            email,
            company_name,
            role,
            created_at,
            updated_at
        )
        VALUES (
            v_user_id,
            'paul@basicwelding.co.uk',
            'BWS LTD',
            'admin',
            now(),
            now()
        )
        ON CONFLICT (id) DO UPDATE
        SET 
            role = 'admin',
            company_name = 'BWS LTD',
            updated_at = now();
    END IF;
END $$; 