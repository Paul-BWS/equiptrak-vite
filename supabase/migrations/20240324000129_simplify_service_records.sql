-- Drop everything first to start clean
DROP TABLE IF EXISTS service_records CASCADE;
DROP SEQUENCE IF EXISTS certificate_number_seq;

-- Create a simple sequence for certificate numbers
CREATE SEQUENCE certificate_number_seq START 24570;

-- Create the service_records table with just the essentials
CREATE TABLE service_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id),
    engineer_id UUID REFERENCES engineers(id),
    equipment_name TEXT,
    equipment_serial TEXT,
    test_date TIMESTAMP WITH TIME ZONE NOT NULL,
    retest_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT DEFAULT 'valid',
    certificate_number TEXT DEFAULT 'BWS-' || nextval('certificate_number_seq')::TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- No RLS, no complex policies, just simple permissions
GRANT ALL ON service_records TO authenticated;
GRANT USAGE ON certificate_number_seq TO authenticated; 