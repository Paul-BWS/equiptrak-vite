-- Revoke PUBLIC permissions
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE USAGE ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;

-- Grant specific permissions to authenticated users only
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO authenticated;

-- Specifically for the certificate number functionality
REVOKE USAGE ON SEQUENCE certificate_number_seq FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION generate_certificate_number() FROM PUBLIC;

GRANT USAGE ON SEQUENCE certificate_number_seq TO authenticated;
GRANT EXECUTE ON FUNCTION generate_certificate_number() TO authenticated; 