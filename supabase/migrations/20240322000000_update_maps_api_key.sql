-- First, delete any existing Google Maps API key
DELETE FROM config WHERE key = 'GOOGLE_MAPS_API_KEY';

-- Then insert the new key
INSERT INTO config (key, value)
VALUES ('GOOGLE_MAPS_API_KEY', 'AIzaSyD60aJEPIY4wu6bj0cP-ATuDVJonjHNz3E'); 