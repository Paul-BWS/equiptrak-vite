-- Add company_id column to service_records
ALTER TABLE service_records
ADD COLUMN company_id UUID REFERENCES companies(id);

-- Create index for better performance
CREATE INDEX idx_service_records_company_id ON service_records(company_id);

-- Grant permissions
GRANT ALL ON service_records TO authenticated; 