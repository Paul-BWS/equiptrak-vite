-- Add telephone field to companies table
ALTER TABLE companies
ADD COLUMN IF NOT EXISTS telephone TEXT; 