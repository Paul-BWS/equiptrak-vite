-- First, ensure the user exists in auth.users and create profile
DO $$
DECLARE
    v_user_id uuid;
BEGIN
    -- Get or create auth user
    INSERT INTO auth.users (email, encrypted_password, email_confirmed_at, raw_user_meta_data)
    VALUES (
        'paul@basicwelding.co.uk',
        crypt('your_password_here', gen_salt('bf')), -- You'll need to set this via Supabase dashboard
        now(),
        jsonb_build_object('role', 'admin', 'company_name', 'BWS LTD')
    )
    ON CONFLICT (email) DO UPDATE
    SET raw_user_meta_data = jsonb_build_object('role', 'admin', 'company_name', 'BWS LTD')
    RETURNING id INTO v_user_id;

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

END $$;

-- Double check the profile exists and has admin role
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM profiles 
        WHERE email = 'paul@basicwelding.co.uk' 
        AND role = 'admin'
    ) THEN
        RAISE EXCEPTION 'Admin profile not created successfully';
    END IF;
END $$; 