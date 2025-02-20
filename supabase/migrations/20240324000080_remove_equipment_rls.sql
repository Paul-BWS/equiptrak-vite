-- Drop all existing policies
DROP POLICY IF EXISTS "equipment_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_select_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_access_policy" ON equipment;

-- Disable RLS completely
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;

-- Grant full permissions to authenticated users
GRANT ALL ON equipment TO authenticated; 