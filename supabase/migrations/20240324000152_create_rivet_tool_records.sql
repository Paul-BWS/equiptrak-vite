-- Create certificate number sequence if it doesn't exist
CREATE SEQUENCE IF NOT EXISTS certificate_number_seq START 1;

-- Drop existing table
DROP TABLE IF EXISTS rivet_tool_records CASCADE;

-- Create rivet tool records table with proper field types and constraints
CREATE TABLE rivet_tool_records (
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
    rivet_tool_model TEXT,
    machine_reading_1 DECIMAL(10,2),
    actual_reading_1 DECIMAL(10,2),
    machine_reading_2 DECIMAL(10,2),
    actual_reading_2 DECIMAL(10,2),
    machine_reading_3 DECIMAL(10,2),
    actual_reading_3 DECIMAL(10,2),
    machine_reading_4 DECIMAL(10,2),
    actual_reading_4 DECIMAL(10,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_rivet_tool_records_company_id ON rivet_tool_records(company_id);
CREATE INDEX idx_rivet_tool_records_test_date ON rivet_tool_records(test_date);
CREATE INDEX idx_rivet_tool_records_retest_date ON rivet_tool_records(retest_date);

-- Disable RLS
ALTER TABLE rivet_tool_records DISABLE ROW LEVEL SECURITY;

-- Grant permissions
GRANT ALL ON rivet_tool_records TO authenticated; 