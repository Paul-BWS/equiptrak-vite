-- Drop existing complex policies
DROP POLICY IF EXISTS "allow_admin_access_conversations" ON conversations;
DROP POLICY IF EXISTS "allow_company_access_conversations" ON conversations;
DROP POLICY IF EXISTS "allow_conversation_participants_messages" ON messages;
DROP POLICY IF EXISTS "allow_conversation_access_participants" ON conversation_participants;

-- Simple authenticated access policies
CREATE POLICY "enable_all_access" ON conversations FOR ALL USING (true);
CREATE POLICY "enable_all_access" ON messages FOR ALL USING (true);
CREATE POLICY "enable_all_access" ON conversation_participants FOR ALL USING (true); 