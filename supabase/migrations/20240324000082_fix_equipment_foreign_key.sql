-- Drop the existing foreign key constraint
ALTER TABLE equipment DROP CONSTRAINT IF EXISTS equipment_customer_id_fkey;

-- Add the correct foreign key constraint referencing companies table
ALTER TABLE equipment ADD CONSTRAINT equipment_customer_id_fkey 
    FOREIGN KEY (customer_id) REFERENCES companies(id)
    ON DELETE CASCADE;

-- Ensure RLS is disabled
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;

-- Grant necessary permissions
GRANT ALL ON equipment TO authenticated; 