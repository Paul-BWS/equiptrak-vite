-- Drop existing policies
DROP POLICY IF EXISTS "equipment_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_select_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_access_policy" ON equipment;

-- Disable RLS temporarily
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;

-- Create new simplified policy for equipment
CREATE POLICY "equipment_access_policy" ON equipment
FOR ALL USING (
    -- Admins can do everything
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can only see equipment for their company
    EXISTS (
        SELECT 1 FROM companies
        WHERE companies.id = equipment.customer_id
    )
);

-- Re-enable RLS
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;

-- Grant necessary permissions
GRANT ALL ON equipment TO authenticated; 