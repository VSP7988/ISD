/*
  # Fix Database Schema and Authentication

  1. Changes
    - Consolidates all schema changes into a single migration
    - Ensures proper order of operations
    - Adds proper existence checks for all objects
    - Creates admin user with correct authentication setup

  2. Tables
    - natural_stones_content
    - natural_stones_gallery

  3. Security
    - Enables RLS on all tables
    - Creates appropriate policies
    - Sets up admin user authentication
*/

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create tables if they don't exist
CREATE TABLE IF NOT EXISTS public.natural_stones_content (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  description TEXT NOT NULL,
  user_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

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

-- Create function for updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers
DROP TRIGGER IF EXISTS handle_updated_at ON public.natural_stones_content;
DROP TRIGGER IF EXISTS handle_updated_at ON public.natural_stones_gallery;

CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.natural_stones_content
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER handle_updated_at
  BEFORE UPDATE ON public.natural_stones_gallery
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

-- Create policies with existence checks
DO $$
BEGIN
    -- Policies for natural_stones_content
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

    -- Policies for natural_stones_gallery
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

-- Create admin user
DO $$
DECLARE
  new_user_id uuid := gen_random_uuid();
BEGIN
  -- Remove existing admin user to avoid conflicts
  DELETE FROM auth.identities WHERE provider_id = 'admin@ishastoneanddecor.com';
  DELETE FROM auth.users WHERE email = 'admin@ishastoneanddecor.com';

  -- Insert user
  INSERT INTO auth.users (
    id,
    instance_id,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    raw_app_meta_data,
    raw_user_meta_data,
    aud,
    role,
    is_super_admin
  ) 
  VALUES (
    new_user_id,
    '00000000-0000-0000-0000-000000000000',
    'admin@ishastoneanddecor.com',
    crypt('Admin@123', gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"provider": "email", "providers": ["email"]}',
    '{"name": "Admin"}',
    'authenticated',
    'authenticated',
    false
  );

  -- Insert identity
  INSERT INTO auth.identities (
    id,
    user_id,
    identity_data,
    provider,
    provider_id,
    last_sign_in_at,
    created_at,
    updated_at
  ) VALUES (
    new_user_id,
    new_user_id,
    jsonb_build_object(
      'sub', new_user_id::text,
      'email', 'admin@ishastoneanddecor.com',
      'email_verified', true
    ),
    'email',
    'admin@ishastoneanddecor.com',
    now(),
    now(),
    now()
  );
END $$;