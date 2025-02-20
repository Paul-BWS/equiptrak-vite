-- Create companies table
CREATE TABLE IF NOT EXISTS companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name TEXT NOT NULL,
    address TEXT,
    city TEXT,
    county TEXT,
    postcode TEXT,
    country TEXT DEFAULT 'United Kingdom',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add unique constraint on company name
ALTER TABLE companies ADD CONSTRAINT unique_company_name UNIQUE (company_name);

-- Enable RLS
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;

-- Create policy for companies
CREATE POLICY "companies_policy" ON companies
FOR ALL USING (
    -- Admins can do everything
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can read all companies
    current_setting('request.method', true) = 'GET'
);

-- Create trigger to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_companies_updated_at
    BEFORE UPDATE ON companies
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Grant access to authenticated users
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON companies TO authenticated;

-- Add test data if no companies exist
INSERT INTO companies (company_name, address, city, county, postcode)
SELECT 
    'Basic Welding Supplies Ltd',
    '123 Main Street',
    'Manchester',
    'Greater Manchester',
    'M1 1AA'
WHERE NOT EXISTS (
    SELECT 1 FROM companies
); 