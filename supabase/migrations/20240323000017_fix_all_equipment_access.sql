-- Drop existing policies
DROP POLICY IF EXISTS "equipment_select_policy" ON equipment;
DROP POLICY IF EXISTS "Users can view their own equipment" ON equipment;
DROP POLICY IF EXISTS "Admins can view all equipment" ON equipment;
DROP POLICY IF EXISTS "admin_access_all_equipment" ON equipment;

-- Equipment policies
CREATE POLICY "admin_access_equipment" ON equipment
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid()
        AND role = 'admin'
    )
);

-- Equipment Types policies
DROP POLICY IF EXISTS "admin_access_equipment_types" ON equipment_types;

CREATE POLICY "admin_access_equipment_types" ON equipment_types
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM profiles
        WHERE id = auth.uid()
        AND role = 'admin'
    )
);