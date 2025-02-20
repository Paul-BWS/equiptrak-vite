-- Drop everything first
DROP TABLE IF EXISTS service_records CASCADE;
DROP SEQUENCE IF EXISTS certificate_number_seq CASCADE;
DROP FUNCTION IF EXISTS generate_certificate_number();

-- Create a dead simple service_records table
CREATE TABLE service_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL,
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

-- Simple certificate sequence
CREATE SEQUENCE certificate_number_seq START 24570;

-- Dead simple certificate function
CREATE FUNCTION generate_certificate_number() RETURNS TEXT AS $$
BEGIN
    RETURN nextval('certificate_number_seq')::TEXT;
END;
$$ LANGUAGE plpgsql;

-- Grant access to authenticated users
GRANT ALL ON service_records TO authenticated;
GRANT USAGE ON certificate_number_seq TO authenticated;
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO authenticated; 