-- Add company_id to contacts table
ALTER TABLE contacts 
ADD COLUMN IF NOT EXISTS company_id UUID REFERENCES companies(id) ON DELETE CASCADE;

-- Create index for performance
CREATE INDEX IF NOT EXISTS idx_contacts_company_id ON contacts(company_id);

-- Update RLS policy for contacts
DROP POLICY IF EXISTS "contacts_policy" ON contacts;
CREATE POLICY "contacts_policy" ON contacts
FOR ALL USING (
    -- Admins can do everything
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can only see contacts from their company
    EXISTS (
        SELECT 1 FROM contacts c
        WHERE c.user_id = auth.uid()
        AND c.company_id = contacts.company_id
    )
);

-- Create a function to migrate existing contacts to companies
DO $$
DECLARE
    contact_record RECORD;
    company_id UUID;
BEGIN
    -- For each contact
    FOR contact_record IN SELECT DISTINCT company_name FROM contacts WHERE company_id IS NULL LOOP
        -- Create company if it doesn't exist
        INSERT INTO companies (company_name)
        VALUES (contact_record.company_name)
        ON CONFLICT (company_name) DO UPDATE
        SET updated_at = NOW()
        RETURNING id INTO company_id;

        -- Update contacts with the company_id
        UPDATE contacts
        SET company_id = company_id
        WHERE company_name = contact_record.company_name
        AND company_id IS NULL;
    END LOOP;
END $$; 