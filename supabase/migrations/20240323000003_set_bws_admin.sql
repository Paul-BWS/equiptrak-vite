-- Ensure BWS admin exists and has proper access
INSERT INTO profiles (id, email, company_name, role)
VALUES (
  (SELECT id FROM auth.users WHERE email = 'paul@basicwelding.co.uk'),
  'paul@basicwelding.co.uk',
  'BWS LTD',
  'admin'
)
ON CONFLICT (id) DO UPDATE
SET role = 'admin',
    company_name = 'BWS LTD';

-- Add sales@basicwelding.co.uk as admin if exists
INSERT INTO profiles (id, email, company_name, role)
SELECT id, email, 'BWS LTD', 'admin'
FROM auth.users 
WHERE email = 'sales@basicwelding.co.uk'
ON CONFLICT (id) DO UPDATE
SET role = 'admin',
    company_name = 'BWS LTD';

-- Note: To disable public sign-ups, this needs to be done through the Supabase dashboard
-- or using the admin API, as it cannot be done directly through SQL migrations.
-- Please disable sign-ups through the Supabase dashboard: Authentication > Settings > Enable email signup 