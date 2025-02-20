-- Drop ALL policies from ALL tables
DO $$ 
DECLARE 
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP POLICY IF EXISTS profiles_policy ON ' || quote_ident(r.tablename);
        EXECUTE 'ALTER TABLE ' || quote_ident(r.tablename) || ' DISABLE ROW LEVEL SECURITY';
    END LOOP;
END $$;

-- Drop and recreate service_records from scratch
DROP TABLE IF EXISTS service_records CASCADE;
CREATE TABLE service_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
    engineer_id TEXT NOT NULL,
    test_date TIMESTAMP WITH TIME ZONE NOT NULL,
    retest_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT DEFAULT 'valid',
    certificate_number TEXT,
    notes TEXT,
    equipment1_name TEXT,
    equipment1_serial TEXT,
    equipment2_name TEXT,
    equipment2_serial TEXT,
    equipment3_name TEXT,
    equipment3_serial TEXT,
    equipment4_name TEXT,
    equipment4_serial TEXT,
    equipment5_name TEXT,
    equipment5_serial TEXT,
    equipment6_name TEXT,
    equipment6_serial TEXT,
    equipment7_name TEXT,
    equipment7_serial TEXT,
    equipment8_name TEXT,
    equipment8_serial TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Drop and recreate certificate sequence
DROP SEQUENCE IF EXISTS certificate_number_seq CASCADE;
CREATE SEQUENCE certificate_number_seq START 24570;

-- Create a super simple certificate function
CREATE OR REPLACE FUNCTION generate_certificate_number() 
RETURNS TEXT 
LANGUAGE SQL 
SECURITY DEFINER 
AS $$
    SELECT nextval('certificate_number_seq')::TEXT;
$$;

-- Grant permissions
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO authenticated; 