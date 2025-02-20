-- Drop all policies from profiles
DROP POLICY IF EXISTS "profiles_policy" ON profiles;

-- Disable RLS on profiles
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Drop existing function and sequence
DROP FUNCTION IF EXISTS generate_certificate_number();
DROP SEQUENCE IF EXISTS certificate_number_seq;

-- Create sequence starting at 24570
CREATE SEQUENCE certificate_number_seq START 24570;

-- Create dead simple function with no policy dependencies
CREATE OR REPLACE FUNCTION generate_certificate_number()
RETURNS TEXT
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT nextval('certificate_number_seq')::TEXT;
$$;

-- Grant permissions to authenticated users
GRANT USAGE ON SEQUENCE certificate_number_seq TO authenticated;
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO authenticated;

-- Grant access to profiles table
GRANT ALL ON profiles TO authenticated; 