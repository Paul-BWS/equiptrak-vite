-- Drop all existing policies from equipment table
DROP POLICY IF EXISTS "equipment_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_select_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_access_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_insert_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_update_policy" ON equipment;
DROP POLICY IF EXISTS "equipment_delete_policy" ON equipment;

-- Disable RLS on equipment table
ALTER TABLE equipment DISABLE ROW LEVEL SECURITY;

-- Grant full access to authenticated users
GRANT ALL ON equipment TO authenticated;

-- Remove any profile-related triggers or functions if they exist
DROP TRIGGER IF EXISTS on_equipment_updated ON equipment;
DROP FUNCTION IF EXISTS handle_equipment_update() CASCADE;

-- Clean up any existing profile-related views
DROP VIEW IF EXISTS equipment_with_profiles CASCADE; 