-- Insert a test engineer
INSERT INTO engineers (id, name) VALUES 
('d7f77d6e-3fc0-4c91-9c8e-ce7b5f0b7048', 'Paul Jones')
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name; 