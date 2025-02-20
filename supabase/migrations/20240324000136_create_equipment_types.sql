-- Drop existing table if it exists
DROP TABLE IF EXISTS equipment_types CASCADE;

-- Create equipment types table
CREATE TABLE equipment_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for better performance
CREATE INDEX idx_equipment_types_name ON equipment_types(name);

-- Disable RLS
ALTER TABLE equipment_types DISABLE ROW LEVEL SECURITY;

-- Grant permissions
GRANT ALL ON equipment_types TO authenticated;

-- Insert standard equipment types
INSERT INTO equipment_types (name, description) VALUES
    ('spot_welder', 'Spot Welder Equipment'),
    ('service', 'General Service Equipment'),
    ('compressor', 'Compressor Equipment'),
    ('welder_validation', 'Welder Validation Equipment'),
    ('rivet_tool', 'Rivet Tools'),
    ('air_con', 'Air Conditioning Machines'),
    ('paint_scales', 'Paint Scales Equipment'),
    ('tyres_gauge', 'Tyres Gauge Equipment'),
    ('torque_wrench', 'Torque Wrench Equipment'),
    ('jig_measuring', 'JIG Measuring Equipment'),
    ('clean_air', 'Clean Air Equipment'),
    ('pressure_gauges', 'Pressure Gauges Equipment'),
    ('measuring_tools', 'Measuring Tools Equipment'),
    ('headlight_beam', 'Headlight Beam Setter Equipment'),
    ('temperature_gauges', 'Temperature Gauges Equipment'),
    ('puwer_inspection', 'PUWER Inspection Equipment'),
    ('lev', 'Local Exhaust Ventilation LEV Equipment'),
    ('air_compressor', 'Tank Inspection Equipment'),
    ('safety_equipment', 'Safety Equipment'),
    ('gas_equipment', 'Gas Equipment CP7'),
    ('loler', 'LOLER Equipment')
ON CONFLICT (name) DO UPDATE 
SET description = EXCLUDED.description; 