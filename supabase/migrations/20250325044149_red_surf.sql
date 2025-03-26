/*
  # Add brochures management tables and storage

  1. New Tables
    - `brochures`
      - `id` (uuid, primary key)
      - `title` (text)
      - `file_url` (text)
      - `category` (text)
      - `user_id` (uuid, references auth.users)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

  2. Storage
    - Creates brochures bucket for PDF storage
    - Sets up appropriate security policies
*/

-- Create brochures table
CREATE TABLE IF NOT EXISTS public.brochures (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  file_url text NOT NULL,
  category text NOT NULL,
  user_id uuid REFERENCES auth.users(id) NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.brochures ENABLE ROW LEVEL SECURITY;

-- Create policies for brochures
CREATE POLICY "Anyone can view brochures"
  ON public.brochures
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can manage brochures"
  ON public.brochures
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Create trigger for updated_at
CREATE TRIGGER update_brochures_updated_at
  BEFORE UPDATE ON public.brochures
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create storage bucket for brochures
INSERT INTO storage.buckets (id, name, public, avif_autodetection, file_size_limit, allowed_mime_types)
VALUES (
  'brochures',
  'brochures',
  true,
  false,
  10485760, -- 10MB limit
  ARRAY['application/pdf']::text[]
)
ON CONFLICT (id) DO UPDATE
SET 
  public = true,
  file_size_limit = 10485760,
  allowed_mime_types = ARRAY['application/pdf']::text[];

-- Create storage policies for brochures bucket
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'brochures');

CREATE POLICY "Authenticated users can upload brochures"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'brochures' 
  AND (auth.uid() = owner OR owner IS NULL)
);

CREATE POLICY "Authenticated users can update their brochures"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'brochures' 
  AND auth.uid() = owner
);

CREATE POLICY "Authenticated users can delete their brochures"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'brochures' 
  AND auth.uid() = owner
);