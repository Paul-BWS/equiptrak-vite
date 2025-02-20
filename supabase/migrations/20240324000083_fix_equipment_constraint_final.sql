-- First, drop any existing foreign key constraints on equipment table
DO $$ 
BEGIN
    -- Drop any FK constraints referencing profiles
    IF EXISTS (
        SELECT 1 
        FROM information_schema.table_constraints 
        WHERE constraint_name = 'equipment_customer_id_fkey' 
        AND table_name = 'equipment'
    ) THEN
        ALTER TABLE equipment DROP CONSTRAINT equipment_customer_id_fkey;
    END IF;
END $$;

-- Drop any triggers that might interfere
DROP TRIGGER IF EXISTS on_equipment_updated ON equipment;
DROP FUNCTION IF EXISTS handle_equipment_update() CASCADE;

-- Drop any views that might depend on the old structure
DROP VIEW IF EXISTS equipment_with_profiles CASCADE;

-- Disable RLS
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;

-- Add the new foreign key constraint
ALTER TABLE equipment 
    ADD CONSTRAINT equipment_customer_id_fkey 
    FOREIGN KEY (customer_id) 
    REFERENCES companies(id) 
    ON DELETE CASCADE;

-- Grant permissions
GRANT ALL ON equipment TO authenticated; 