-- First drop the existing foreign key constraint
ALTER TABLE equipment
DROP CONSTRAINT IF EXISTS equipment_customer_id_fkey;

-- Add new foreign key constraint referencing companies table
ALTER TABLE equipment
ADD CONSTRAINT equipment_customer_id_fkey
FOREIGN KEY (customer_id) REFERENCES companies(id);

-- Disable RLS for equipment table since auth is handled at app level
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;

-- Update any existing equipment records to point to the correct company
UPDATE equipment e
SET customer_id = c.id
FROM profiles p
JOIN companies c ON p.company_name = c.company_name
WHERE e.customer_id = p.id;

-- Fix profiles RLS policy
DROP POLICY IF EXISTS "profiles_policy" ON profiles;
CREATE POLICY "profiles_policy" ON profiles
FOR ALL USING (
  auth.uid() = id OR 
  auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
);

-- Insert equipment types
INSERT INTO equipment_types (name, description) VALUES
  ('service', 'General Service Equipment'),
  ('spot_welder', 'Spot Welder Equipment'),
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

-- Grant necessary permissions
GRANT ALL ON equipment TO authenticated;

-- Clean up any existing spot welder records
DELETE FROM spot_welder_service_records; 