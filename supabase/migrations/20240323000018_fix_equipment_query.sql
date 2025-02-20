-- First, ensure equipment table has all required columns
ALTER TABLE equipment 
ADD COLUMN IF NOT EXISTS last_test_date TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS next_test_date TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'valid';

-- Drop and recreate the equipment policy
DROP POLICY IF EXISTS "admin_access_equipment" ON equipment;
DROP POLICY IF EXISTS "equipment_select_policy" ON equipment;

-- Create a new policy that allows profile joins
CREATE POLICY "equipment_access_policy" ON equipment
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM profiles
        WHERE profiles.id = auth.uid()
        AND (
            -- User is an admin
            profiles.role = 'admin'
            OR
            -- Or equipment belongs to user's company
            profiles.company_name = (
                SELECT company_name FROM profiles WHERE id = equipment.customer_id
            )
        )
    )
); 