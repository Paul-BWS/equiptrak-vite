-- First, let's check the current constraint
DO $$ 
BEGIN
    -- Drop any existing constraint
    IF EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'equipment_customer_id_fkey' 
        AND table_name = 'equipment'
    ) THEN
        ALTER TABLE equipment DROP CONSTRAINT equipment_customer_id_fkey;
    END IF;
END $$;

-- Disable RLS completely
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;

-- Add the constraint back, explicitly referencing companies(id)
ALTER TABLE equipment 
    ADD CONSTRAINT equipment_customer_id_fkey 
    FOREIGN KEY (customer_id) 
    REFERENCES companies(id) 
    ON DELETE CASCADE;

-- Grant necessary permissions
GRANT ALL ON equipment TO authenticated;

-- Verify the company exists
DO $$ 
DECLARE
    company_exists boolean;
BEGIN
    SELECT EXISTS (
        SELECT 1 
        FROM companies 
        WHERE id = '436eba15-a826-439b-abc5-c17cd9b6e075'
    ) INTO company_exists;
    
    IF NOT company_exists THEN 
        RAISE EXCEPTION 'Company with ID 436eba15-a826-439b-abc5-c17cd9b6e075 does not exist in companies table';
    END IF;
END $$; 