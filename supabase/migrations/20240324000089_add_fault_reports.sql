-- Create enum for fault report status
CREATE TYPE fault_report_status AS ENUM ('new', 'in_progress', 'resolved', 'closed');

-- Create fault reports table
CREATE TABLE fault_reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    description TEXT NOT NULL,
    status fault_report_status DEFAULT 'new',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    resolved_at TIMESTAMPTZ,
    created_by UUID REFERENCES auth.users(id),
    assigned_to UUID REFERENCES auth.users(id),
    resolution_notes TEXT
);

-- Add RLS policies
ALTER TABLE fault_reports ENABLE ROW LEVEL SECURITY;

-- Allow admins to see all fault reports
CREATE POLICY "admins_all_access" ON fault_reports
FOR ALL USING (
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
);

-- Allow users to create fault reports
CREATE POLICY "users_can_create" ON fault_reports
FOR INSERT WITH CHECK (true);

-- Allow users to see their own fault reports
CREATE POLICY "users_read_own" ON fault_reports
FOR SELECT USING (
    auth.uid() = created_by
);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
CREATE TRIGGER update_fault_reports_updated_at
    BEFORE UPDATE ON fault_reports
    FOR EACH ROW
    EXECUTE PROCEDURE update_updated_at_column();

-- Grant access to authenticated users
GRANT ALL ON fault_reports TO authenticated;
GRANT USAGE ON TYPE fault_report_status TO authenticated; 