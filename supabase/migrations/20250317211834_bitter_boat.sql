/*
  # Enhance Natural Stones tables with improved security and constraints

  1. Changes
    - Add user_id foreign key to both tables
    - Enable RLS on all tables
    - Add proper constraints and defaults
    - Add detailed security policies
    - Ensure data integrity with proper relationships

  2. Security
    - Enable RLS on both tables
    - Add policies for authenticated users
    - Ensure proper user isolation
*/

-- Add user_id and enhance natural_stones_content
ALTER TABLE public.natural_stones_content
  ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id),
  ALTER COLUMN created_at SET DEFAULT now(),
  ALTER COLUMN updated_at SET DEFAULT now();

-- Add user_id and enhance natural_stones_gallery
ALTER TABLE public.natural_stones_gallery
  ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id),
  ALTER COLUMN created_at SET DEFAULT now(),
  ALTER COLUMN updated_at SET DEFAULT now(),
  ADD CONSTRAINT unique_order UNIQUE ("order");

-- Enable RLS
ALTER TABLE public.natural_stones_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.natural_stones_gallery ENABLE ROW LEVEL SECURITY;

-- Create policies for natural_stones_content
CREATE POLICY "Users can view all content"
  ON public.natural_stones_content
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Users can update their own content"
  ON public.natural_stones_content
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can insert with their id"
  ON public.natural_stones_content
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own content"
  ON public.natural_stones_content
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create policies for natural_stones_gallery
CREATE POLICY "Anyone can view gallery"
  ON public.natural_stones_gallery
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Users can update their own gallery items"
  ON public.natural_stones_gallery
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can insert with their id"
  ON public.natural_stones_gallery
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own gallery items"
  ON public.natural_stones_gallery
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.natural_stones_content
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.natural_stones_gallery
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();