-- Drop existing policies
DROP POLICY IF EXISTS "Enable admin access to conversations" ON conversations;
DROP POLICY IF EXISTS "Enable customer access to conversations" ON conversations;
DROP POLICY IF EXISTS "Enable admin access to messages" ON messages;
DROP POLICY IF EXISTS "Enable customer access to messages" ON messages;
DROP POLICY IF EXISTS "Enable admin access to conversation_participants" ON conversation_participants;
DROP POLICY IF EXISTS "Enable customer access to conversation_participants" ON conversation_participants;

-- Enable RLS
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversation_participants ENABLE ROW LEVEL SECURITY;

-- Conversations policies
CREATE POLICY "Enable admin access to conversations"
ON conversations
FOR ALL
TO authenticated
USING (
  auth.jwt() ->> 'role' = 'admin'
)
WITH CHECK (
  auth.jwt() ->> 'role' = 'admin'
);

CREATE POLICY "Enable customer access to conversations"
ON conversations
FOR ALL
TO authenticated
USING (
  (auth.jwt() ->> 'role' = 'customer' AND customer_id = auth.uid()) OR
  EXISTS (
    SELECT 1 FROM conversation_participants
    WHERE conversation_participants.conversation_id = conversations.id
    AND conversation_participants.user_id = auth.uid()
  )
)
WITH CHECK (
  (auth.jwt() ->> 'role' = 'customer' AND customer_id = auth.uid()) OR
  EXISTS (
    SELECT 1 FROM conversation_participants
    WHERE conversation_participants.conversation_id = conversations.id
    AND conversation_participants.user_id = auth.uid()
  )
);

-- Messages policies
CREATE POLICY "Enable admin access to messages"
ON messages
FOR ALL
TO authenticated
USING (
  auth.jwt() ->> 'role' = 'admin'
)
WITH CHECK (
  auth.jwt() ->> 'role' = 'admin'
);

CREATE POLICY "Enable customer access to messages"
ON messages
FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM conversations c
    WHERE c.id = messages.conversation_id
    AND (
      c.customer_id = auth.uid() OR
      EXISTS (
        SELECT 1 FROM conversation_participants cp
        WHERE cp.conversation_id = c.id
        AND cp.user_id = auth.uid()
      )
    )
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM conversations c
    WHERE c.id = messages.conversation_id
    AND (
      c.customer_id = auth.uid() OR
      EXISTS (
        SELECT 1 FROM conversation_participants cp
        WHERE cp.conversation_id = c.id
        AND cp.user_id = auth.uid()
      )
    )
  )
);

-- Conversation participants policies
CREATE POLICY "Enable admin access to conversation_participants"
ON conversation_participants
FOR ALL
TO authenticated
USING (
  auth.jwt() ->> 'role' = 'admin'
)
WITH CHECK (
  auth.jwt() ->> 'role' = 'admin'
);

CREATE POLICY "Enable customer access to conversation_participants"
ON conversation_participants
FOR ALL
TO authenticated
USING (
  user_id = auth.uid() OR
  EXISTS (
    SELECT 1 FROM conversations c
    WHERE c.id = conversation_participants.conversation_id
    AND c.customer_id = auth.uid()
  )
)
WITH CHECK (
  user_id = auth.uid() OR
  EXISTS (
    SELECT 1 FROM conversations c
    WHERE c.id = conversation_participants.conversation_id
    AND c.customer_id = auth.uid()
  )
); 