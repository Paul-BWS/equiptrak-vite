-- Enable pgcrypto extension
CREATE EXTENSION IF NOT EXISTS pgcrypto SCHEMA public;

-- Grant usage on pgcrypto functions to authenticated users
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO authenticated;

-- Verify pgcrypto is installed and accessible
DO $$
BEGIN
    -- Test gen_salt function
    PERFORM gen_salt('bf');
    
    -- If we get here, pgcrypto is working
    RAISE NOTICE 'pgcrypto extension is properly installed and accessible';
EXCEPTION WHEN OTHERS THEN
    RAISE EXCEPTION 'Failed to verify pgcrypto installation: %', SQLERRM;
END $$; 