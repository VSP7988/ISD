/*
  # Create Tables and Policies with Existence Checks
  
  1. Changes
    - Creates tables if they don't exist
    - Adds user_id and timestamp columns
    - Enables RLS
    - Creates policies with existence checks
    - Sets up triggers for updated_at
*/

-- Create natural_stones_content table
CREATE TABLE IF NOT EXISTS public.natural_stones_content (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  description TEXT NOT NULL,
  user_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create natural_stones_gallery table
CREATE TABLE IF NOT EXISTS public.natural_stones_gallery (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  image_url TEXT NOT NULL,
  "order" INTEGER NOT NULL,
  user_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT unique_order UNIQUE ("order")
);

-- Enable RLS
ALTER TABLE public.natural_stones_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.natural_stones_gallery ENABLE ROW LEVEL SECURITY;

-- Create policies for natural_stones_content with existence checks
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'natural_stones_content' 
        AND policyname = 'Users can view all content'
    ) THEN
        CREATE POLICY "Users can view all content"
          ON public.natural_stones_content
          FOR SELECT
          TO public
          USING (true);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'natural_stones_content' 
        AND policyname = 'Users can update their own content'
    ) THEN
        CREATE POLICY "Users can update their own content"
          ON public.natural_stones_content
          FOR UPDATE
          TO authenticated
          USING (auth.uid() = user_id)
          WITH CHECK (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'natural_stones_content' 
        AND policyname = 'Users can insert with their id'
    ) THEN
        CREATE POLICY "Users can insert with their id"
          ON public.natural_stones_content
          FOR INSERT
          TO authenticated
          WITH CHECK (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'natural_stones_content' 
        AND policyname = 'Users can delete their own content'
    ) THEN
        CREATE POLICY "Users can delete their own content"
          ON public.natural_stones_content
          FOR DELETE
          TO authenticated
          USING (auth.uid() = user_id);
    END IF;
END $$;

-- Create policies for natural_stones_gallery with existence checks
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'natural_stones_gallery' 
        AND policyname = 'Anyone can view gallery'
    ) THEN
        CREATE POLICY "Anyone can view gallery"
          ON public.natural_stones_gallery
          FOR SELECT
          TO public
          USING (true);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'natural_stones_gallery' 
        AND policyname = 'Users can update their own gallery items'
    ) THEN
        CREATE POLICY "Users can update their own gallery items"
          ON public.natural_stones_gallery
          FOR UPDATE
          TO authenticated
          USING (auth.uid() = user_id)
          WITH CHECK (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'natural_stones_gallery' 
        AND policyname = 'Users can insert with their id'
    ) THEN
        CREATE POLICY "Users can insert with their id"
          ON public.natural_stones_gallery
          FOR INSERT
          TO authenticated
          WITH CHECK (auth.uid() = user_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'natural_stones_gallery' 
        AND policyname = 'Users can delete their own gallery items'
    ) THEN
        CREATE POLICY "Users can delete their own gallery items"
          ON public.natural_stones_gallery
          FOR DELETE
          TO authenticated
          USING (auth.uid() = user_id);
    END IF;
END $$;

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop existing triggers if they exist
DROP TRIGGER IF EXISTS handle_updated_at ON public.natural_stones_content;
DROP TRIGGER IF EXISTS handle_updated_at ON public.natural_stones_gallery;

-- Create triggers for updated_at
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.natural_stones_content
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.natural_stones_gallery
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();