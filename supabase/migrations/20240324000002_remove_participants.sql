-- Drop ALL existing policies
DROP POLICY IF EXISTS "Enable admin access to conversations" ON conversations;
DROP POLICY IF EXISTS "Enable customer access to own conversations" ON conversations;
DROP POLICY IF EXISTS "Allow admins full access to conversations" ON conversations;
DROP POLICY IF EXISTS "Allow customers to view their own conversations" ON conversations;
DROP POLICY IF EXISTS "Enable all access for authenticated users" ON conversations;

DROP POLICY IF EXISTS "Enable admin access to messages" ON messages;
DROP POLICY IF EXISTS "Enable customer access to conversation messages" ON messages;
DROP POLICY IF EXISTS "Allow admins full access to messages" ON messages;
DROP POLICY IF EXISTS "Allow customers to view messages in their conversations" ON messages;
DROP POLICY IF EXISTS "Allow customers to send messages in their conversations" ON messages;
DROP POLICY IF EXISTS "Enable all access for authenticated users" ON messages;

-- Create conversation_participants table if it doesn't exist
CREATE TABLE IF NOT EXISTS conversation_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(conversation_id, user_id)
);

-- Enable RLS on all tables
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversation_participants ENABLE ROW LEVEL SECURITY;

-- Create policies for conversations
CREATE POLICY "Enable admin access to conversations"
ON conversations FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM profiles
        WHERE profiles.id = auth.uid()
        AND profiles.role = 'admin'
    )
);

CREATE POLICY "Enable participant access to conversations"
ON conversations FOR ALL
USING (
    customer_id = auth.uid()
    OR EXISTS (
        SELECT 1 FROM conversation_participants
        WHERE conversation_participants.conversation_id = conversations.id
        AND conversation_participants.user_id = auth.uid()
    )
);

-- Create policies for messages
CREATE POLICY "Enable admin access to messages"
ON messages FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM profiles
        WHERE profiles.id = auth.uid()
        AND profiles.role = 'admin'
    )
);

CREATE POLICY "Enable participant access to messages"
ON messages FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM conversation_participants
        WHERE conversation_participants.conversation_id = messages.conversation_id
        AND conversation_participants.user_id = auth.uid()
    )
    OR EXISTS (
        SELECT 1 FROM conversations
        WHERE conversations.id = messages.conversation_id
        AND conversations.customer_id = auth.uid()
    )
);

-- Create policies for conversation_participants
CREATE POLICY "Enable admin access to participants"
ON conversation_participants FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM profiles
        WHERE profiles.id = auth.uid()
        AND profiles.role = 'admin'
    )
);

CREATE POLICY "Enable participant access to own participation"
ON conversation_participants FOR ALL
USING (user_id = auth.uid()); 