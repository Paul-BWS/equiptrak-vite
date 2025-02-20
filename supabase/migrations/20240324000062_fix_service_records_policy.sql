-- Enable RLS on service_records table
ALTER TABLE service_records ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any
DROP POLICY IF EXISTS "service_records_policy" ON service_records;

-- Create policy for service records
CREATE POLICY "service_records_policy" ON service_records
FOR ALL USING (
    -- Admins can do everything
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can read their own service records
    EXISTS (
        SELECT 1 FROM equipment e
        WHERE e.id = service_records.equipment_id
        AND e.customer_id = auth.uid()
    )
);

-- Grant necessary permissions
GRANT ALL ON service_records TO authenticated; 