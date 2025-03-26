/*
  # Create Natural Stones Content Tables

  1. New Tables
    - `natural_stones_content`
      - `id` (uuid, primary key)
      - `description` (text)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    
    - `natural_stones_gallery`
      - `id` (uuid, primary key)
      - `title` (text)
      - `image_url` (text)
      - `order` (integer)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on both tables
    - Add policies for authenticated users to manage content
*/

-- Create natural stones content table
CREATE TABLE IF NOT EXISTS natural_stones_content (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  description text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create natural stones gallery table
CREATE TABLE IF NOT EXISTS natural_stones_gallery (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  image_url text NOT NULL,
  "order" integer NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE natural_stones_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE natural_stones_gallery ENABLE ROW LEVEL SECURITY;

-- Create policies for natural_stones_content
CREATE POLICY "Allow public read access to natural stones content"
  ON natural_stones_content
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Allow authenticated users to update natural stones content"
  ON natural_stones_content
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Create policies for natural_stones_gallery
CREATE POLICY "Allow public read access to natural stones gallery"
  ON natural_stones_gallery
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Allow authenticated users to manage natural stones gallery"
  ON natural_stones_gallery
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);