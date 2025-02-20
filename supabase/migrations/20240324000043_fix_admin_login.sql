-- Disable RLS temporarily
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Reset admin user completely
DO $$
DECLARE
    admin_id uuid;
BEGIN
    -- Remove existing admin entries
    DELETE FROM auth.users WHERE email = 'paul@basicwelding.co.uk';
    DELETE FROM profiles WHERE email = 'paul@basicwelding.co.uk';
    
    -- Create new admin user with a secure password
    INSERT INTO auth.users (
        instance_id,
        id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        invited_at,
        confirmation_token,
        confirmation_sent_at,
        recovery_token,
        recovery_sent_at,
        email_change_token_new,
        email_change,
        email_change_sent_at,
        last_sign_in_at,
        raw_app_meta_data,
        raw_user_meta_data,
        is_super_admin,
        created_at,
        updated_at,
        phone,
        phone_confirmed_at,
        phone_change,
        phone_change_token,
        phone_change_sent_at,
        confirmed_at,
        email_change_token_current,
        email_change_confirm_status,
        banned_until,
        reauthentication_token,
        reauthentication_sent_at,
        is_sso_user,
        deleted_at
    )
    VALUES (
        (SELECT id FROM auth.instances LIMIT 1),  -- instance_id
        gen_random_uuid(),  -- id
        'authenticated',    -- aud
        'authenticated',    -- role
        'paul@basicwelding.co.uk',  -- email
        crypt('password123', gen_salt('bf')),  -- encrypted_password
        NOW(),             -- email_confirmed_at
        null,              -- invited_at
        '',                -- confirmation_token
        NOW(),            -- confirmation_sent_at
        '',               -- recovery_token
        null,             -- recovery_sent_at
        '',               -- email_change_token_new
        '',               -- email_change
        null,             -- email_change_sent_at
        NOW(),            -- last_sign_in_at
        '{"provider": "email", "providers": ["email"]}',  -- raw_app_meta_data
        '{"role": "admin", "company_name": "BWS LTD"}'::jsonb,  -- raw_user_meta_data
        false,            -- is_super_admin
        NOW(),           -- created_at
        NOW(),           -- updated_at
        null,            -- phone
        null,            -- phone_confirmed_at
        '',              -- phone_change
        '',              -- phone_change_token
        null,            -- phone_change_sent_at
        NOW(),           -- confirmed_at
        '',              -- email_change_token_current
        0,               -- email_change_confirm_status
        null,            -- banned_until
        '',              -- reauthentication_token
        null,            -- reauthentication_sent_at
        false,           -- is_sso_user
        null             -- deleted_at
    )
    RETURNING id INTO admin_id;

    -- Create matching profile
    INSERT INTO profiles (
        id,
        email,
        role,
        company_name,
        created_at,
        updated_at
    )
    VALUES (
        admin_id,
        'paul@basicwelding.co.uk',
        'admin',
        'BWS LTD',
        NOW(),
        NOW()
    );

    -- Verify creation
    IF NOT EXISTS (
        SELECT 1 FROM auth.users 
        WHERE email = 'paul@basicwelding.co.uk' 
        AND confirmed_at IS NOT NULL
        AND encrypted_password IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Failed to create admin user';
    END IF;
END $$;

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT ON profiles TO anon;
GRANT ALL ON profiles TO authenticated;

-- Verify the setup
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM auth.users u
        JOIN profiles p ON u.id = p.id
        WHERE u.email = 'paul@basicwelding.co.uk'
        AND p.role = 'admin'
        AND u.confirmed_at IS NOT NULL
        AND u.encrypted_password IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Admin user verification failed';
    END IF;
END $$; 