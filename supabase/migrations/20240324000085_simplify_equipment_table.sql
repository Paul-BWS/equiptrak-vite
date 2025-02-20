-- Drop all constraints and policies first
ALTER TABLE equipment DROP CONSTRAINT IF EXISTS equipment_customer_id_fkey;
DROP POLICY IF EXISTS "equipment_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_select_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_access_policy" ON equipment;

-- Disable RLS
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;

-- Add simple foreign key to companies table
ALTER TABLE equipment 
    ADD CONSTRAINT equipment_customer_id_fkey 
    FOREIGN KEY (customer_id) 
    REFERENCES companies(id);

-- Grant permissions
GRANT ALL ON equipment TO authenticated; 