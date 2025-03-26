/*
  # Fix Storage Policies for Brochures

  1. Changes
    - Drops existing policies to avoid conflicts
    - Creates new policies with proper owner handling
    - Ensures proper RLS configuration
*/

-- Enable RLS on objects table if not already enabled
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to avoid conflicts
DO $$
BEGIN
    DROP POLICY IF EXISTS "Public Access" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can upload brochures" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can update their brochures" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can delete their brochures" ON storage.objects;
END $$;

-- Create storage policies with proper owner handling
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'brochures');

CREATE POLICY "Authenticated users can upload brochures"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'brochures' 
  AND (owner IS NULL OR owner = auth.uid())
);

CREATE POLICY "Authenticated users can update their brochures"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'brochures' 
  AND owner = auth.uid()
);

CREATE POLICY "Authenticated users can delete their brochures"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'brochures' 
  AND owner = auth.uid()
);

-- Update bucket configuration
UPDATE storage.buckets
SET public = true,
    file_size_limit = 10485760,
    allowed_mime_types = ARRAY['application/pdf']::text[]
WHERE id = 'brochures';