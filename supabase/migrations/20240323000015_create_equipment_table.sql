-- Create equipment table
CREATE TABLE IF NOT EXISTS equipment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    serial_number TEXT NOT NULL,
    customer_id UUID REFERENCES profiles(id),
    status TEXT DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "equipment_select_policy" ON equipment
FOR SELECT USING (
    -- Admins can see all equipment
    EXISTS (
        SELECT 1 FROM user_roles
        WHERE user_id = auth.uid() 
        AND role = 'admin'
    )
    OR
    -- Users can see their own company's equipment
    customer_id = auth.uid()
);

-- Add some test equipment for BWS
INSERT INTO equipment (name, serial_number, customer_id, status)
VALUES 
    ('Test Welder 1', 'SN001', '42c4aca3-d7bd-49b5-8b7b-1013e9ff92ba', 'active'),
    ('Test Welder 2', 'SN002', '42c4aca3-d7bd-49b5-8b7b-1013e9ff92ba', 'active'); 