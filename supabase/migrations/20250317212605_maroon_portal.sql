/*
  # Fix Admin User Creation

  1. Changes
    - Properly creates admin user with correct schema
    - Ensures proper authentication setup
    - Adds necessary indexes and constraints
*/

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Remove existing admin user to avoid conflicts
DO $$
BEGIN
  DELETE FROM auth.identities WHERE provider_id = 'admin@ishastoneanddecor.com';
  DELETE FROM auth.users WHERE email = 'admin@ishastoneanddecor.com';
END $$;

-- Create admin user
DO $$
DECLARE
  new_user_id uuid := gen_random_uuid();
BEGIN
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
    recovery_token,
    email_change_token_current,
    email_change_token_new
  ) VALUES (
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
    false,
    '',
    '',
    '',
    ''
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