/*
  # Remove Natural Stones Management Tables and Storage

  1. Changes
    - Removes all objects from the natural-stones storage bucket
    - Drops the storage bucket
    - Drops natural stones related tables
    - Removes associated storage policies
*/

-- First, delete all objects in the natural-stones bucket
DELETE FROM storage.objects WHERE bucket_id = 'natural-stones';

-- Drop natural stones tables
DROP TABLE IF EXISTS public.natural_stones_gallery;
DROP TABLE IF EXISTS public.natural_stones_content;

-- Drop storage bucket policies
DO $$
BEGIN
    DROP POLICY IF EXISTS "Public Access" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can upload images" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can update their images" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can delete their images" ON storage.objects;
END $$;

-- Now we can safely delete the bucket
DELETE FROM storage.buckets WHERE id = 'natural-stones';