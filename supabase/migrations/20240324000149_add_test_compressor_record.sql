-- Insert a test record
INSERT INTO compressor_records (
    company_id,
    engineer_name,
    test_date,
    retest_date,
    equipment_name,
    equipment_serial,
    pressure_test_result,
    safety_valve_test,
    oil_level,
    belt_condition,
    compressor_model,
    notes
) VALUES (
    '436eba15-a826-439b-abc5-c17cd9b6e075', -- Replace with an actual company_id from your companies table
    'Paul Jones',
    NOW(),
    NOW() + INTERVAL '1 year',
    'Test Compressor',
    'COMP-001',
    'pass',
    'pass',
    'good',
    'good',
    'Atlas Copco GA11',
    'Initial test record'
);

-- Verify the insert
SELECT * FROM compressor_records ORDER BY created_at DESC LIMIT 1; 