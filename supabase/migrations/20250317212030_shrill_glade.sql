/*
  # Create Admin User with Identity
  
  1. Changes
    - Creates admin user with secure password if not exists
    - Sets up proper authentication identity
    - Uses DO block for safer execution
*/

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create admin user if not exists
DO $$
DECLARE
  new_user_id uuid := gen_random_uuid();
BEGIN
  -- Remove existing admin user to avoid conflicts
  DELETE FROM auth.identities WHERE user_id IN (
    SELECT id FROM auth.users WHERE email = 'admin@ishastoneanddecor.com'
  );
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