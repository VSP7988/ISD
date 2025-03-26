/*
  # Fix Storage Policies

  1. Changes
    - Ensures storage schema exists
    - Creates storage bucket with proper configuration
    - Sets up correct RLS policies for authenticated users
    - Fixes owner field handling in policies
*/

-- Create storage bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public, avif_autodetection, file_size_limit, allowed_mime_types)
VALUES (
  'natural-stones',
  'natural-stones',
  true,
  false,
  2097152, -- 2MB in bytes
  ARRAY['image/jpeg', 'image/png', 'image/webp']::text[]
)
ON CONFLICT (id) DO UPDATE
SET 
  public = true,
  file_size_limit = 2097152,
  allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/webp']::text[];

-- Enable RLS
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DO $$
BEGIN
    DROP POLICY IF EXISTS "Public Access" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can upload images" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can update their images" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can delete their images" ON storage.objects;
END $$;

-- Create storage policy to allow public read access
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'natural-stones');

-- Create storage policy to allow authenticated users to upload files
CREATE POLICY "Authenticated users can upload images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'natural-stones' 
  AND (auth.uid() = owner OR owner IS NULL)
);

-- Create storage policy to allow authenticated users to update their files
CREATE POLICY "Authenticated users can update their images"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'natural-stones' 
  AND auth.uid() = owner
)
WITH CHECK (
  bucket_id = 'natural-stones' 
  AND auth.uid() = owner
);

-- Create storage policy to allow authenticated users to delete their files
CREATE POLICY "Authenticated users can delete their images"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'natural-stones' 
  AND auth.uid() = owner
);