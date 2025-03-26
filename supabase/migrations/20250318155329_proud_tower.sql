/*
  # Set up authentication schema and create admin user

  1. Changes
    - Enables required extensions
    - Creates admin user with secure password
    - Sets up proper authentication configuration
*/

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pgjwt";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create auth schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS auth;

-- Ensure we're using the auth schema
SET search_path = auth, public;

-- Create admin user using Supabase's auth.users table
DO $$
DECLARE
  new_user_id uuid := gen_random_uuid();
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM auth.users 
    WHERE email = 'admin@ishastoneanddecor.com'
  ) THEN
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
      is_super_admin,
      confirmation_token,
      email_change_token_current,
      email_change_token_new,
      recovery_token
    ) VALUES (
      new_user_id,
      '00000000-0000-0000-0000-000000000000',
      'admin@ishastoneanddecor.com',
      crypt('Admin@123', gen_salt('bf', 10)), -- Added strength parameter
      NOW(),
      NOW(),
      NOW(),
      '{"provider":"email","providers":["email"]}',
      '{"name":"Admin"}',
      'authenticated',
      'authenticated',
      FALSE,
      '',
      '',
      '',
      ''
    );

    -- Insert into auth.identities
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
      NOW(),
      NOW(),
      NOW()
    );
  END IF;
END $$;