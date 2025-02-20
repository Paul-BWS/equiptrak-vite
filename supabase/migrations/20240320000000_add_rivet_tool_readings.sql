-- Create the rivet tool service records table
CREATE TABLE IF NOT EXISTS rivet_tool_service_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    equipment_id UUID REFERENCES equipment(id),
    service_date DATE NOT NULL,
    next_service_date DATE,
    technician TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add machine settings and actual readings columns
ALTER TABLE rivet_tool_service_records
ADD COLUMN machine_setting_1 numeric,
ADD COLUMN machine_setting_2 numeric,
ADD COLUMN machine_setting_3 numeric,
ADD COLUMN machine_setting_4 numeric,
ADD COLUMN actual_reading_1 numeric,
ADD COLUMN actual_reading_2 numeric,
ADD COLUMN actual_reading_3 numeric,
ADD COLUMN actual_reading_4 numeric; 