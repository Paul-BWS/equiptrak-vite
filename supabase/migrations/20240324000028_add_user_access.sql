-- Add user access tracking to contacts
ALTER TABLE contacts 
ADD COLUMN has_user_access boolean DEFAULT false,
ADD COLUMN user_id uuid REFERENCES auth.users(id),
ADD COLUMN last_login timestamp with time zone;

-- Create an index for performance
CREATE INDEX idx_contacts_user_id ON contacts(user_id) WHERE user_id IS NOT NULL;

-- Add a unique constraint to prevent multiple contacts having the same user
ALTER TABLE contacts 
ADD CONSTRAINT unique_user_id UNIQUE (user_id);

-- Add RLS policy for contacts
CREATE POLICY "contacts_policy" ON contacts
FOR ALL USING (
    -- Admins can do everything
    auth.jwt() ->> 'email' IN ('paul@basicwelding.co.uk', 'sales@basicwelding.co.uk')
    OR
    -- Users can only see contacts from their company
    company_id IN (
        SELECT company_id 
        FROM contacts 
        WHERE user_id = auth.uid()
    )
); 