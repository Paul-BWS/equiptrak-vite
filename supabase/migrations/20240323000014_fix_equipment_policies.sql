-- Drop any existing equipment policies
DROP POLICY IF EXISTS "Users can view their own equipment" ON equipment;
DROP POLICY IF EXISTS "Admins can view all equipment" ON equipment;

-- Create policies for equipment table
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

-- Allow admins to insert/update/delete
CREATE POLICY "equipment_admin_all" ON equipment
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM user_roles
        WHERE user_id = auth.uid() 
        AND role = 'admin'
    )
); 