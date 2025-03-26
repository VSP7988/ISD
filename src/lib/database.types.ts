export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      site_settings: {
        Row: {
          id: string
          logo_url: string | null
          user_id: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          logo_url?: string | null
          user_id: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          logo_url?: string | null
          user_id?: string
          created_at?: string
          updated_at?: string
        }
      }
      natural_stones_content: {
        Row: {
          id: string
          description: string
          user_id: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          description: string
          user_id: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          description?: string
          user_id?: string
          created_at?: string
          updated_at?: string
        }
      }
      natural_stones_gallery: {
        Row: {
          id: string
          title: string
          image_url: string
          order: number
          user_id: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          title: string
          image_url: string
          order: number
          user_id: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          title?: string
          image_url?: string
          order?: number
          user_id?: string
          created_at?: string
          updated_at?: string
        }
      }
    }
  }
}