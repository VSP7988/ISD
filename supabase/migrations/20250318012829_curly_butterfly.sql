/*
  # Create storage bucket for natural stones images

  1. Changes
    - Creates a new storage bucket for natural stones images
    - Sets up public access policies for the bucket
    - Adds policies for authenticated users to manage their files
*/

-- Create the storage bucket
INSERT INTO storage.buckets (id, name, public, avif_autodetection, file_size_limit, allowed_mime_types)
VALUES (
  'natural-stones',
  'natural-stones',
  true,
  false,
  104857600, -- 100MB in bytes
  ARRAY['image/jpeg', 'image/png', 'image/webp']::text[]
)
ON CONFLICT (id) DO NOTHING;

-- Create storage policy to allow public read access
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
TO public
USING ( bucket_id = 'natural-stones' );

-- Create storage policy to allow authenticated users to upload files
CREATE POLICY "Authenticated users can upload images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK ( bucket_id = 'natural-stones' );

-- Create storage policy to allow authenticated users to update their files
CREATE POLICY "Authenticated users can update their images"
ON storage.objects FOR UPDATE
TO authenticated
USING ( bucket_id = 'natural-stones' AND auth.uid() = owner );

-- Create storage policy to allow authenticated users to delete their files
CREATE POLICY "Authenticated users can delete their images"
ON storage.objects FOR DELETE
TO authenticated
USING ( bucket_id = 'natural-stones' AND auth.uid() = owner );