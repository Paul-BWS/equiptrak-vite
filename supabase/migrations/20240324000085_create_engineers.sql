-- Create engineers table
CREATE TABLE engineers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for better performance
CREATE INDEX idx_engineers_name ON engineers(name);

-- No RLS needed as per requirements
ALTER TABLE engineers DISABLE ROW LEVEL SECURITY;

-- Grant permissions
GRANT ALL ON engineers TO authenticated; 