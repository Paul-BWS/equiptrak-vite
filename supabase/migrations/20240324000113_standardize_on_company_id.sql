-- Drop and recreate service_records with ONLY company_id
DROP TABLE IF EXISTS service_records CASCADE;

CREATE TABLE service_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL,  -- This is the ONLY ID field we'll use for company/customer reference
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

-- Create index
CREATE INDEX idx_service_records_company_id ON service_records(company_id);

-- Create sequence for certificate numbers
DROP SEQUENCE IF EXISTS certificate_number_seq CASCADE;
CREATE SEQUENCE certificate_number_seq START 24570;

-- Create simple certificate function
CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE sql
AS $$
    SELECT nextval('certificate_number_seq')::TEXT;
$$;

-- Grant permissions
GRANT ALL ON service_records TO authenticated;
GRANT USAGE ON certificate_number_seq TO authenticated;
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO authenticated; 