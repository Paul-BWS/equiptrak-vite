-- Drop everything first
DROP FUNCTION IF EXISTS generate_certificate_number();
DROP SEQUENCE IF EXISTS certificate_number_seq;

-- Create dead simple sequence and function
CREATE SEQUENCE certificate_number_seq START 24570;

CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE sql
AS $$
  SELECT nextval('certificate_number_seq')::TEXT;
$$;

-- Disable RLS on core tables
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE companies DISABLE ROW LEVEL SECURITY;
ALTER TABLE service_records DISABLE ROW LEVEL SECURITY;

-- Drop any existing policies
DROP POLICY IF EXISTS "profiles_policy" ON profiles;
DROP POLICY IF EXISTS "companies_policy" ON companies;

-- Grant permissions
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO authenticated; 