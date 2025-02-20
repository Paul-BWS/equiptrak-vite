-- Spot Welder Records
DROP TABLE IF EXISTS spot_welder_records CASCADE;
CREATE TABLE spot_welder_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    test_date TIMESTAMP WITH TIME ZONE NOT NULL,
    retest_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT DEFAULT 'valid',
    certificate_number TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- LOLER Records
DROP TABLE IF EXISTS loler_records CASCADE;
CREATE TABLE loler_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    test_date TIMESTAMP WITH TIME ZONE NOT NULL,
    retest_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT DEFAULT 'valid',
    certificate_number TEXT,
    notes TEXT,
    safe_working_load TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Compressor Records
DROP TABLE IF EXISTS compressor_records CASCADE;
CREATE TABLE compressor_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    test_date TIMESTAMP WITH TIME ZONE NOT NULL,
    retest_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT DEFAULT 'valid',
    certificate_number TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Rivet Tool Records
DROP TABLE IF EXISTS rivet_tool_records CASCADE;
CREATE TABLE rivet_tool_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    test_date TIMESTAMP WITH TIME ZONE NOT NULL,
    retest_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT DEFAULT 'valid',
    certificate_number TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_spot_welder_records_company_id ON spot_welder_records(company_id);
CREATE INDEX idx_spot_welder_records_test_date ON spot_welder_records(test_date);

CREATE INDEX idx_loler_records_company_id ON loler_records(company_id);
CREATE INDEX idx_loler_records_test_date ON loler_records(test_date);

CREATE INDEX idx_compressor_records_company_id ON compressor_records(company_id);
CREATE INDEX idx_compressor_records_test_date ON compressor_records(test_date);

CREATE INDEX idx_rivet_tool_records_company_id ON rivet_tool_records(company_id);
CREATE INDEX idx_rivet_tool_records_test_date ON rivet_tool_records(test_date);

-- Disable RLS for all tables
ALTER TABLE spot_welder_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE loler_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE compressor_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE rivet_tool_records DISABLE ROW LEVEL SECURITY;

-- Grant permissions
GRANT ALL ON spot_welder_records TO authenticated;
GRANT ALL ON loler_records TO authenticated;
GRANT ALL ON compressor_records TO authenticated;
GRANT ALL ON rivet_tool_records TO authenticated; 