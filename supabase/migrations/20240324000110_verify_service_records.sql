-- First, let's check if the table exists and drop it if it does
DROP TABLE IF EXISTS service_records CASCADE;

-- Now create the table with a minimal but correct structure
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
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index
CREATE INDEX idx_service_records_company_id ON service_records(company_id);

-- Grant permissions
GRANT ALL ON service_records TO authenticated;

-- Verify the structure
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'service_records' 
        AND column_name = 'company_id'
    ) THEN 
        RAISE EXCEPTION 'company_id column does not exist in service_records table';
    END IF;
END $$; 