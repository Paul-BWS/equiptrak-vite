-- Disable RLS on all tables
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE companies DISABLE ROW LEVEL SECURITY;
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;
ALTER TABLE service_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE spot_welder_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE loler_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE compressor_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE rivet_tool_records DISABLE ROW LEVEL SECURITY;
ALTER TABLE engineers DISABLE ROW LEVEL SECURITY;

-- Drop any existing RLS policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;
DROP POLICY IF EXISTS "companies_policy" ON companies;
DROP POLICY IF EXISTS "equipment_policy" ON equipment;

-- Simple certificate number function
DROP FUNCTION IF EXISTS generate_certificate_number();
DROP SEQUENCE IF EXISTS certificate_number_seq;

CREATE SEQUENCE certificate_number_seq START 24570;

CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE sql
AS $$
  SELECT nextval('certificate_number_seq')::TEXT;
$$;

-- Grant permissions to authenticated users
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO authenticated; 