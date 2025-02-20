-- First, make sure the table is dropped cleanly
DROP TABLE IF EXISTS spot_welder_service_records CASCADE;

-- Create the table with minimal required fields first
CREATE TABLE spot_welder_service_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL,
    test_date TIMESTAMP WITH TIME ZONE NOT NULL,
    retest_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT DEFAULT 'valid',
    certificate_number TEXT,
    notes TEXT,
    equipment_name TEXT NOT NULL,
    equipment_serial TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_spot_welder_company_id ON spot_welder_service_records(company_id);
CREATE INDEX idx_spot_welder_test_date ON spot_welder_service_records(test_date);

-- Disable RLS
ALTER TABLE spot_welder_service_records DISABLE ROW LEVEL SECURITY;

-- Grant permissions
GRANT ALL ON spot_welder_service_records TO authenticated;

-- Insert a test record to verify the table works
INSERT INTO spot_welder_service_records (
    company_id,
    test_date,
    retest_date,
    equipment_name,
    equipment_serial
) VALUES (
    '0cd307a7-c938-49da-b005-17746587ca8a',
    NOW(),
    NOW() + INTERVAL '1 year',
    'Test Spot Welder',
    'TSW-001'
); 