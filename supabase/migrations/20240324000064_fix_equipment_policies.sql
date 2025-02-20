-- Enable RLS
ALTER TABLE equipment ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "equipment_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_select_policy" ON equipment;

-- Create new policy for equipment
CREATE POLICY "equipment_policy" ON equipment
FOR ALL USING (
    -- Admins can do everything
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can only see their own equipment
    customer_id = auth.uid()
);

-- Grant necessary permissions
GRANT ALL ON equipment TO authenticated; 