-- Add industry and website fields to companies table
ALTER TABLE companies
ADD COLUMN IF NOT EXISTS industry TEXT,
ADD COLUMN IF NOT EXISTS website TEXT;

-- Update RLS policy to ensure it covers the new fields
DROP POLICY IF EXISTS "companies_access_policy" ON companies;
CREATE POLICY "companies_access_policy" ON companies
FOR ALL USING (
    -- Direct check for admin emails
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Allow all authenticated users to read companies
    (
        auth.role() = 'authenticated' 
        AND 
        current_setting('request.method', true) = 'GET'
    )
);

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON companies TO authenticated; 