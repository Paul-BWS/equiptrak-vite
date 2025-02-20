-- Temporarily disable chat functionality
DROP TABLE IF EXISTS conversations CASCADE;
DROP TABLE IF EXISTS messages CASCADE;
DROP TABLE IF EXISTS participants CASCADE;

-- Drop any related functions
DROP FUNCTION IF EXISTS handle_new_message() CASCADE;
DROP FUNCTION IF EXISTS handle_new_conversation() CASCADE;

-- Drop any related triggers
DROP TRIGGER IF EXISTS on_message_created ON messages;
DROP TRIGGER IF EXISTS on_conversation_created ON conversations; 