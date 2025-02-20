-- Drop and recreate compressor records table with proper certificate number
DROP TABLE IF EXISTS compressor_records CASCADE;

-- Create compressor records table with all fields
CREATE TABLE compressor_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    engineer_name TEXT NOT NULL,
    test_date TIMESTAMP WITH TIME ZONE NOT NULL,
    retest_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT DEFAULT 'valid',
    certificate_number TEXT DEFAULT 'BWS-' || nextval('certificate_number_seq')::TEXT,
    notes TEXT,
    equipment_name TEXT NOT NULL,
    equipment_serial TEXT NOT NULL,
    compressor_model TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_compressor_records_company_id ON compressor_records(company_id);
CREATE INDEX idx_compressor_records_test_date ON compressor_records(test_date);
CREATE INDEX idx_compressor_records_retest_date ON compressor_records(retest_date);

-- Disable RLS
ALTER TABLE compressor_records DISABLE ROW LEVEL SECURITY;

-- Grant permissions
GRANT ALL ON compressor_records TO authenticated; 