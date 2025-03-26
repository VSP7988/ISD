/*
  # Fix Authentication Schema Setup

  1. Changes
    - Creates auth schema if not exists
    - Enables all required extensions
    - Sets up auth schema tables if missing
    - Recreates admin user with proper schema structure
*/

-- Create auth schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS auth;

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pgjwt";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create auth schema tables if they don't exist
CREATE TABLE IF NOT EXISTS auth.users (
    id uuid NOT NULL PRIMARY KEY,
    instance_id uuid,
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone character varying(15) DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change character varying(15) DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false,
    deleted_at timestamp with time zone,
    CONSTRAINT users_email_key UNIQUE (email),
    CONSTRAINT users_phone_key UNIQUE (phone)
);

CREATE TABLE IF NOT EXISTS auth.identities (
    id uuid NOT NULL PRIMARY KEY,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    provider_id text,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

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
    email_change_token_new,
    phone,
    phone_confirmed_at,
    phone_change,
    phone_change_token,
    email_change,
    banned_until,
    reauthentication_token,
    reauthentication_sent_at,
    is_sso_user,
    deleted_at
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
    '',
    null,
    null,
    null,
    '',
    '',
    null,
    '',
    null,
    false,
    null
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