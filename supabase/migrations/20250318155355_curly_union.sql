/*
  # Fix admin authentication setup

  1. Changes
    - Creates admin user with proper authentication schema
    - Sets up correct user metadata and authentication details
    - Ensures proper provider configuration
*/

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create admin user if not exists
DO $$
DECLARE
  new_user_id uuid;
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM auth.users 
    WHERE email = 'admin@ishastoneanddecor.com'
  ) THEN
    -- Insert user
    INSERT INTO auth.users (
      id,
      email,
      encrypted_password,
      email_confirmed_at,
      created_at,
      updated_at,
      raw_app_meta_data,
      raw_user_meta_data,
      aud,
      role
    ) 
    VALUES (
      gen_random_uuid(),
      'admin@ishastoneanddecor.com',
      crypt('Admin@123', gen_salt('bf')),
      now(),
      now(),
      now(),
      '{"provider": "email", "providers": ["email"]}',
      '{"name": "Admin"}',
      'authenticated',
      'authenticated'
    )
    RETURNING id INTO new_user_id;

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
        'email', 'admin@ishastoneanddecor.com'
      ),
      'email',
      'admin@ishastoneanddecor.com',
      now(),
      now(),
      now()
    );
  END IF;
END $$;