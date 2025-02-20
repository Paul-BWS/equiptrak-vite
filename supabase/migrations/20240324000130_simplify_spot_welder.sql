-- Drop existing spot welder tables and related objects
DROP TABLE IF EXISTS spot_welder_service_records CASCADE;
DROP TABLE IF EXISTS equipment CASCADE;
DROP TABLE IF EXISTS equipment_types CASCADE;

-- Create a simple spot welder records table
CREATE TABLE spot_welder_service_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    test_date TIMESTAMP WITH TIME ZONE NOT NULL,
    retest_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT DEFAULT 'valid',
    certificate_number TEXT DEFAULT 'BWS-' || nextval('certificate_number_seq')::TEXT,
    notes TEXT,
    equipment_name TEXT NOT NULL,
    equipment_serial TEXT NOT NULL,
    voltage_max NUMERIC,
    voltage_min NUMERIC,
    air_pressure NUMERIC,
    tip_pressure NUMERIC,
    length NUMERIC,
    diameter NUMERIC,
    max_current NUMERIC,
    electrode_force NUMERIC,
    welding_time_1 NUMERIC,
    welding_time_2 NUMERIC,
    welding_time_3 NUMERIC,
    welding_time_4 NUMERIC,
    machine_time_1 NUMERIC,
    machine_time_2 NUMERIC,
    machine_time_3 NUMERIC,
    machine_time_4 NUMERIC,
    welding_current_1 NUMERIC,
    welding_current_2 NUMERIC,
    welding_current_3 NUMERIC,
    welding_current_4 NUMERIC,
    machine_current_1 NUMERIC,
    machine_current_2 NUMERIC,
    machine_current_3 NUMERIC,
    machine_current_4 NUMERIC,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_spot_welder_records_company_id ON spot_welder_service_records(company_id);
CREATE INDEX idx_spot_welder_records_test_date ON spot_welder_service_records(test_date);

-- Disable RLS
ALTER TABLE spot_welder_service_records DISABLE ROW LEVEL SECURITY;

-- Grant permissions
GRANT ALL ON spot_welder_service_records TO authenticated; 