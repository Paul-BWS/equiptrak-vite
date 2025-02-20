-- First, ensure the companies table exists
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

-- Add unique constraint on company name if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'unique_company_name'
    ) THEN
        ALTER TABLE companies ADD CONSTRAINT unique_company_name UNIQUE (company_name);
    END IF;
END $$;

-- Ensure Basic Welding Supplies exists
INSERT INTO companies (company_name, address, city, county, postcode)
VALUES (
    'Basic Welding Supplies Ltd',
    '123 Main Street',
    'Manchester',
    'Greater Manchester',
    'M1 1AA'
)
ON CONFLICT (company_name) DO NOTHING;

-- Disable RLS for companies
ALTER TABLE companies DISABLE ROW LEVEL SECURITY;

-- Grant permissions
GRANT ALL ON companies TO authenticated; 