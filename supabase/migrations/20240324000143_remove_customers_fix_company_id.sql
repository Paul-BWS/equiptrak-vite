-- Drop customers table and related views
DROP TABLE IF EXISTS customers CASCADE;
DROP VIEW IF EXISTS customer_view CASCADE;

-- Ensure company_id references are correct in all equipment tables
ALTER TABLE spot_welder_service_records 
    DROP CONSTRAINT IF EXISTS spot_welder_service_records_company_id_fkey,
    ADD CONSTRAINT spot_welder_service_records_company_id_fkey 
    FOREIGN KEY (company_id) 
    REFERENCES companies(id) 
    ON DELETE CASCADE;

ALTER TABLE service_records 
    DROP CONSTRAINT IF EXISTS service_records_company_id_fkey,
    ADD CONSTRAINT service_records_company_id_fkey 
    FOREIGN KEY (company_id) 
    REFERENCES companies(id) 
    ON DELETE CASCADE;

ALTER TABLE loler_records 
    DROP CONSTRAINT IF EXISTS loler_records_company_id_fkey,
    ADD CONSTRAINT loler_records_company_id_fkey 
    FOREIGN KEY (company_id) 
    REFERENCES companies(id) 
    ON DELETE CASCADE;

ALTER TABLE compressor_records 
    DROP CONSTRAINT IF EXISTS compressor_records_company_id_fkey,
    ADD CONSTRAINT compressor_records_company_id_fkey 
    FOREIGN KEY (company_id) 
    REFERENCES companies(id) 
    ON DELETE CASCADE;

ALTER TABLE rivet_tool_records 
    DROP CONSTRAINT IF EXISTS rivet_tool_records_company_id_fkey,
    ADD CONSTRAINT rivet_tool_records_company_id_fkey 
    FOREIGN KEY (company_id) 
    REFERENCES companies(id) 
    ON DELETE CASCADE;

-- Disable RLS on all tables to simplify permissions
ALTER TABLE spot_welder_service_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE service_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE loler_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE compressor_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE rivet_tool_records DISABLE ROW LEVEL SECURITY;

-- Grant permissions to authenticated users
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated; 