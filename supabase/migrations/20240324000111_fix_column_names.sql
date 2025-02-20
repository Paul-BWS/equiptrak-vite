-- First, copy data from customer_id to company_id if needed
UPDATE service_records 
SET company_id = customer_id 
WHERE customer_id IS NOT NULL AND company_id IS NULL;

-- Drop the customer_id column
ALTER TABLE service_records DROP COLUMN IF EXISTS customer_id;

-- Make sure company_id is NOT NULL
ALTER TABLE service_records 
ALTER COLUMN company_id SET NOT NULL;

-- Recreate the index
DROP INDEX IF EXISTS idx_service_records_company_id;
CREATE INDEX idx_service_records_company_id ON service_records(company_id);

-- Grant permissions
GRANT ALL ON service_records TO authenticated; 