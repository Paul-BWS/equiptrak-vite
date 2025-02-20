-- Drop existing equipment policies
DROP POLICY IF EXISTS "equipment_select_policy" ON equipment;
DROP POLICY IF EXISTS "Users can view their own equipment" ON equipment;
DROP POLICY IF EXISTS "Admins can view all equipment" ON equipment;

-- Create new simplified policy
CREATE POLICY "admin_access_all_equipment" ON equipment
FOR ALL USING (
    -- Simple admin check
    EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid()
        AND role = 'admin'
    )
); 