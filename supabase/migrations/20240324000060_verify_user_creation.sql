-- Check the most recently created user
SELECT 
    u.id,
    u.email,
    u.role,
    u.created_at,
    p.company_name,
    p.role as profile_role
FROM auth.users u
JOIN profiles p ON u.id = p.id
WHERE u.created_at > now() - interval '5 minutes'
ORDER BY u.created_at DESC
LIMIT 1; 