-- Drop ALL existing policies
DROP POLICY IF EXISTS "admin_access_conversations" ON conversations;
DROP POLICY IF EXISTS "customer_access_conversations" ON conversations;
DROP POLICY IF EXISTS "admin_access_messages" ON messages;
DROP POLICY IF EXISTS "customer_access_messages" ON messages;
DROP POLICY IF EXISTS "admin_access_participants" ON conversation_participants;
DROP POLICY IF EXISTS "customer_access_participants" ON conversation_participants;

-- Disable RLS on conversation_participants
ALTER TABLE conversation_participants DISABLE ROW LEVEL SECURITY;

-- Simple policies for conversations
CREATE POLICY "admin_access_conversations"
ON conversations FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM profiles
        WHERE profiles.id = auth.uid()
        AND profiles.role = 'admin'
    )
);

CREATE POLICY "customer_access_conversations"
ON conversations FOR ALL
USING (customer_id = auth.uid());

-- Simple policies for messages
CREATE POLICY "admin_access_messages"
ON messages FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM profiles
        WHERE profiles.id = auth.uid()
        AND profiles.role = 'admin'
    )
);

CREATE POLICY "customer_access_messages"
ON messages FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM conversations
        WHERE conversations.id = conversation_id
        AND conversations.customer_id = auth.uid()
    )
); 