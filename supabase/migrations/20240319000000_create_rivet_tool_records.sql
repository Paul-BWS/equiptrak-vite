-- Create rivet tool service records table
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