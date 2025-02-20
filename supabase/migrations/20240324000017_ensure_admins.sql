-- Ensure admin users exist with correct roles
INSERT INTO profiles (
    email,
    role,
    company_name
)
VALUES 
    ('paul@basicwelding.co.uk', 'admin', 'Basic Welding'),
    ('sales@basicwelding.co.uk', 'admin', 'Basic Welding')
ON CONFLICT (email) 
DO UPDATE SET role = 'admin'
WHERE profiles.email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk');

-- Verify admin roles
DO $$
BEGIN
    ASSERT (
        SELECT COUNT(*) = 2 
        FROM profiles 
        WHERE email IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
        AND role = 'admin'
    ), 'Admin users not properly configured';
END $$; 