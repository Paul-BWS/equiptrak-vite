-- Create a view that combines all equipment records
CREATE OR REPLACE VIEW all_equipment AS
SELECT 
    id,
    company_id,
    'service' as equipment_type,
    test_date,
    retest_date,
    status,
    certificate_number,
    notes,
    created_at
FROM service_records

UNION ALL

SELECT 
    id,
    company_id,
    'spot_welder' as equipment_type,
    test_date,
    retest_date,
    status,
    certificate_number,
    notes,
    created_at
FROM spot_welder_records

UNION ALL

SELECT 
    id,
    company_id,
    'loler' as equipment_type,
    test_date,
    retest_date,
    status,
    certificate_number,
    notes || CASE 
        WHEN safe_working_load IS NOT NULL 
        THEN E'\nSafe Working Load: ' || safe_working_load 
        ELSE '' 
    END as notes,
    created_at
FROM loler_records

UNION ALL

SELECT 
    id,
    company_id,
    'compressor' as equipment_type,
    test_date,
    retest_date,
    status,
    certificate_number,
    notes,
    created_at
FROM compressor_records

UNION ALL

SELECT 
    id,
    company_id,
    'rivet_tool' as equipment_type,
    test_date,
    retest_date,
    status,
    certificate_number,
    notes,
    created_at
FROM rivet_tool_records;

-- Grant access to the view
GRANT SELECT ON all_equipment TO authenticated;

-- Create an index on companies to speed up joins
CREATE INDEX IF NOT EXISTS idx_companies_id ON companies(id);

-- Create indexes on retest_date for all record tables to improve date filtering
CREATE INDEX IF NOT EXISTS idx_service_records_retest ON service_records(retest_date);
CREATE INDEX IF NOT EXISTS idx_spot_welder_records_retest ON spot_welder_records(retest_date);
CREATE INDEX IF NOT EXISTS idx_loler_records_retest ON loler_records(retest_date);
CREATE INDEX IF NOT EXISTS idx_compressor_records_retest ON compressor_records(retest_date);
CREATE INDEX IF NOT EXISTS idx_rivet_tool_records_retest ON rivet_tool_records(retest_date); 