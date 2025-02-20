-- Drop existing service_records table
DROP TABLE IF EXISTS service_records CASCADE;

-- Create service_records table with correct structure
CREATE TABLE service_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    engineer_id UUID NOT NULL REFERENCES engineers(id),
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

-- Create indexes
CREATE INDEX idx_service_records_company_id ON service_records(company_id);
CREATE INDEX idx_service_records_test_date ON service_records(test_date);
CREATE INDEX idx_service_records_retest_date ON service_records(retest_date);

-- Disable RLS
ALTER TABLE service_records DISABLE ROW LEVEL SECURITY;

-- Drop and recreate certificate number sequence
DROP SEQUENCE IF EXISTS certificate_number_seq;
CREATE SEQUENCE certificate_number_seq START 24570;

-- Drop and recreate certificate function
DROP FUNCTION IF EXISTS generate_certificate_number();
CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    next_num INT;
BEGIN
    SELECT nextval('certificate_number_seq') INTO next_num;
    RETURN next_num::TEXT;
END;
$$;

-- Grant permissions
GRANT ALL ON service_records TO authenticated;
GRANT USAGE ON SEQUENCE certificate_number_seq TO authenticated;
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO authenticated;

-- Fix profiles policy
DROP POLICY IF EXISTS "profiles_policy" ON profiles;
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (
    auth.uid() = id OR 
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
); 