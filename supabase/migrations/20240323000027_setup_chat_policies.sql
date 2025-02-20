-- Drop existing policies
DROP POLICY IF EXISTS "Enable all access for authenticated users" ON conversations;
DROP POLICY IF EXISTS "Enable all access for authenticated users" ON messages;
DROP POLICY IF EXISTS "Enable all access for authenticated users" ON conversation_participants;

-- Enable RLS on chat-related tables
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversation_participants ENABLE ROW LEVEL SECURITY;

-- Policies for conversations
CREATE POLICY "allow_admin_access_conversations"
ON conversations FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM profiles
        WHERE profiles.id = auth.uid()
        AND profiles.role = 'admin'
    )
);

CREATE POLICY "allow_company_access_conversations"
ON conversations FOR ALL
USING (
    company_id = auth.uid()
    OR
    EXISTS (
        SELECT 1 FROM conversation_participants
        WHERE conversation_participants.conversation_id = conversations.id
        AND conversation_participants.user_id = auth.uid()
    )
);

-- Policies for messages
CREATE POLICY "allow_conversation_participants_messages"
ON messages FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM conversation_participants
        WHERE conversation_participants.conversation_id = messages.conversation_id
        AND conversation_participants.user_id = auth.uid()
    )
    OR
    EXISTS (
        SELECT 1 FROM profiles
        WHERE profiles.id = auth.uid()
        AND profiles.role = 'admin'
    )
);

-- Policies for conversation participants
CREATE POLICY "allow_conversation_access_participants"
ON conversation_participants FOR ALL
USING (
    user_id = auth.uid()
    OR
    EXISTS (
        SELECT 1 FROM profiles
        WHERE profiles.id = auth.uid()
        AND profiles.role = 'admin'
    )
); 