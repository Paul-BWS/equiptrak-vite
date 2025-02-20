-- Create LOLER service records table
CREATE TABLE loler_service_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  equipment_id UUID REFERENCES equipment(id) ON DELETE CASCADE,
  engineer_id UUID REFERENCES engineers(id),
  certificate_number TEXT NOT NULL,
  inspection_date DATE NOT NULL,
  retest_date DATE NOT NULL,
  capacity_kg NUMERIC,
  safe_to_operate TEXT CHECK (safe_to_operate IN ('Yes', 'No', 'Remedial')),
  
  -- Action Results
  platform_condition_result TEXT CHECK (platform_condition_result IN ('PASS', 'REMEDIAL', 'FAIL')),
  control_box_result TEXT CHECK (control_box_result IN ('PASS', 'REMEDIAL', 'FAIL')),
  hydraulic_system_result TEXT CHECK (hydraulic_system_result IN ('PASS', 'REMEDIAL', 'FAIL')),
  main_structure_result TEXT CHECK (main_structure_result IN ('PASS', 'REMEDIAL', 'FAIL')),
  oil_levels_result TEXT CHECK (oil_levels_result IN ('PASS', 'REMEDIAL', 'FAIL')),
  rollers_guides_result TEXT CHECK (rollers_guides_result IN ('PASS', 'REMEDIAL', 'FAIL')),
  safety_mechanism_result TEXT CHECK (safety_mechanism_result IN ('PASS', 'REMEDIAL', 'FAIL')),
  scissor_operation_result TEXT CHECK (scissor_operation_result IN ('PASS', 'REMEDIAL', 'FAIL')),
  securing_bolts_result TEXT CHECK (securing_bolts_result IN ('PASS', 'REMEDIAL', 'FAIL')),
  toe_guards_result TEXT CHECK (toe_guards_result IN ('PASS', 'REMEDIAL', 'FAIL')),
  lubrication_result TEXT CHECK (lubrication_result IN ('PASS', 'REMEDIAL', 'FAIL')),
  
  -- Action Notes
  platform_condition_notes TEXT,
  control_box_notes TEXT,
  hydraulic_system_notes TEXT,
  main_structure_notes TEXT,
  oil_levels_notes TEXT,
  rollers_guides_notes TEXT,
  safety_mechanism_notes TEXT,
  scissor_operation_notes TEXT,
  securing_bolts_notes TEXT,
  toe_guards_notes TEXT,
  lubrication_notes TEXT,
  
  -- Additional Fields
  observations TEXT,
  qualifications TEXT DEFAULT 'HNC Electrical Mechanical Engineering'
);

-- Add LOLER equipment type
INSERT INTO equipment_types (name, description)
VALUES ('loler', 'LOLER Inspection Equipment');

-- Add RLS policies
ALTER TABLE loler_service_records ENABLE ROW LEVEL SECURITY;

-- Allow admin users to view all records
CREATE POLICY "Admin users can view all loler records"
  ON loler_service_records
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'admin'
    )
  );

-- Allow customers to view their own records
CREATE POLICY "Customers can view their own loler records"
  ON loler_service_records
  FOR SELECT
  USING (
    equipment_id IN (
      SELECT id FROM equipment
      WHERE customer_id IN (
        SELECT id FROM profiles
        WHERE id = auth.uid()
        AND role = 'customer'
      )
    )
  );

-- Allow admin users to insert records
CREATE POLICY "Admin users can insert loler records"
  ON loler_service_records
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'admin'
    )
  );

-- Allow admin users to update records
CREATE POLICY "Admin users can update loler records"
  ON loler_service_records
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'admin'
    )
  );

-- Allow admin users to delete records
CREATE POLICY "Admin users can delete loler records"
  ON loler_service_records
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'admin'
    )
  );

-- Create function to auto-update retest_date
CREATE OR REPLACE FUNCTION set_loler_retest_date()
RETURNS TRIGGER AS $$
BEGIN
  NEW.retest_date := NEW.inspection_date + INTERVAL '364 days';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_loler_retest_date_trigger
  BEFORE INSERT OR UPDATE OF inspection_date
  ON loler_service_records
  FOR EACH ROW
  EXECUTE FUNCTION set_loler_retest_date(); 