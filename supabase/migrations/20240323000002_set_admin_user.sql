-- Set admin user
UPDATE profiles 
SET role = 'admin'::user_role 
WHERE email = 'paul@basicwelding.co.uk'; 