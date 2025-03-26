/*
  # Fix Authentication Login

  1. Changes
    - Updates admin user creation with proper password hashing
    - Sets correct metadata and authentication fields
    - Ensures proper identity setup
*/

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pgjwt";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create auth schema if not exists
CREATE SCHEMA IF NOT EXISTS auth;

-- Remove existing admin user to avoid conflicts
DO $$
BEGIN
  DELETE FROM auth.identities WHERE provider_id = 'admin@ishastoneanddecor.com';
  DELETE FROM auth.users WHERE email = 'admin@ishastoneanddecor.com';
END $$;

-- Create admin user with proper password hashing
DO $$
DECLARE
  new_user_id uuid := gen_random_uuid();
  encrypted_pass text;
BEGIN
  -- Generate properly hashed password
  encrypted_pass := crypt('Admin@123', gen_salt('bf', 10));

  -- Insert user with proper metadata
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
    is_super_admin,
    confirmation_token,
    recovery_token,
    email_change_token_current,
    email_change_token_new,
    aud,
    role
  ) VALUES (
    new_user_id,
    '00000000-0000-0000-0000-000000000000',
    'admin@ishastoneanddecor.com',
    encrypted_pass,
    now(),
    now(),
    now(),
    jsonb_build_object(
      'provider', 'email',
      'providers', ARRAY['email']
    ),
    jsonb_build_object(
      'name', 'Admin'
    ),
    false,
    '',
    '',
    '',
    '',
    'authenticated',
    'authenticated'
  );

  -- Insert identity with correct metadata
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
      'email_verified', true,
      'phone_verified', false
    ),
    'email',
    'admin@ishastoneanddecor.com',
    now(),
    now(),
    now()
  );
END $$;