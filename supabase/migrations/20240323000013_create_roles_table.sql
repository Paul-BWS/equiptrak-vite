-- Create a separate roles table
CREATE TABLE IF NOT EXISTS user_roles (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id),
    role TEXT NOT NULL CHECK (role IN ('admin', 'customer')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

-- Simple policy for reading roles
CREATE POLICY "allow_read_own_role" ON user_roles
    FOR SELECT USING (true);

-- Insert your admin role
INSERT INTO user_roles (user_id, role)
VALUES ('42c4aca3-d7bd-49b5-8b7b-1013e9ff92ba', 'admin')
ON CONFLICT (user_id) DO UPDATE SET role = 'admin'; 