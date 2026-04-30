export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: '14.5'
  }
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          extensions?: Json
          operationName?: string
          query?: string
          variables?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      access_scope: {
        Row: {
          access_scope_id: string
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          scope_opd_id: string | null
          scope_pegawai_id: string | null
          scope_type: string
          scope_unit_kerja_id: string | null
          updated_at: string
          updated_by: string | null
          user_role_id: string
          valid_from: string | null
          valid_until: string | null
        }
        Insert: {
          access_scope_id: string
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          scope_opd_id?: string | null
          scope_pegawai_id?: string | null
          scope_type: string
          scope_unit_kerja_id?: string | null
          updated_at?: string
          updated_by?: string | null
          user_role_id: string
          valid_from?: string | null
          valid_until?: string | null
        }
        Update: {
          access_scope_id?: string
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          scope_opd_id?: string | null
          scope_pegawai_id?: string | null
          scope_type?: string
          scope_unit_kerja_id?: string | null
          updated_at?: string
          updated_by?: string | null
          user_role_id?: string
          valid_from?: string | null
          valid_until?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_access_scope_opd'
            columns: ['scope_opd_id']
            isOneToOne: false
            referencedRelation: 'master_opd'
            referencedColumns: ['opd_id']
          },
          {
            foreignKeyName: 'fk_access_scope_pegawai'
            columns: ['scope_pegawai_id']
            isOneToOne: false
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
          {
            foreignKeyName: 'fk_access_scope_unit_kerja'
            columns: ['scope_unit_kerja_id']
            isOneToOne: false
            referencedRelation: 'master_unit_kerja'
            referencedColumns: ['unit_kerja_id']
          },
          {
            foreignKeyName: 'fk_access_scope_user_role'
            columns: ['user_role_id']
            isOneToOne: false
            referencedRelation: 'user_roles'
            referencedColumns: ['user_role_id']
          },
        ]
      }
      app_settings: {
        Row: {
          setting_id: string
          setting_key: string
          setting_value: string | null
          setting_type: string
          kategori: string
          label: string
          deskripsi: string | null
          urutan: number
          is_public: boolean
          created_at: string
          updated_at: string
          created_by: string | null
          updated_by: string | null
        }
        Insert: {
          setting_id: string
          setting_key: string
          setting_value?: string | null
          setting_type?: string
          kategori?: string
          label: string
          deskripsi?: string | null
          urutan?: number
          is_public?: boolean
          created_at?: string
          updated_at?: string
          created_by?: string | null
          updated_by?: string | null
        }
        Update: {
          setting_id?: string
          setting_key?: string
          setting_value?: string | null
          setting_type?: string
          kategori?: string
          label?: string
          deskripsi?: string | null
          urutan?: number
          is_public?: boolean
          created_at?: string
          updated_at?: string
          created_by?: string | null
          updated_by?: string | null
        }
        Relationships: []
      }
      approval_log: {
        Row: {
          actor_user_id: string
          aksi_approval_id: string
          approval_log_id: string
          catatan: string | null
          created_at: string
          created_by: string | null
          riwayat_usulan_id: string
          status_sebelum_id: string | null
          status_sesudah_id: string | null
          tanggal_aksi: string
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          actor_user_id: string
          aksi_approval_id: string
          approval_log_id: string
          catatan?: string | null
          created_at?: string
          created_by?: string | null
          riwayat_usulan_id: string
          status_sebelum_id?: string | null
          status_sesudah_id?: string | null
          tanggal_aksi: string
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          actor_user_id?: string
          aksi_approval_id?: string
          approval_log_id?: string
          catatan?: string | null
          created_at?: string
          created_by?: string | null
          riwayat_usulan_id?: string
          status_sebelum_id?: string | null
          status_sesudah_id?: string | null
          tanggal_aksi?: string
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_approval_log_actor'
            columns: ['actor_user_id']
            isOneToOne: false
            referencedRelation: 'users'
            referencedColumns: ['user_id']
          },
          {
            foreignKeyName: 'fk_approval_log_aksi'
            columns: ['aksi_approval_id']
            isOneToOne: false
            referencedRelation: 'master_aksi_approval'
            referencedColumns: ['aksi_approval_id']
          },
          {
            foreignKeyName: 'fk_approval_log_status_sebelum'
            columns: ['status_sebelum_id']
            isOneToOne: false
            referencedRelation: 'master_status_usulan'
            referencedColumns: ['status_usulan_id']
          },
          {
            foreignKeyName: 'fk_approval_log_status_sesudah'
            columns: ['status_sesudah_id']
            isOneToOne: false
            referencedRelation: 'master_status_usulan'
            referencedColumns: ['status_usulan_id']
          },
          {
            foreignKeyName: 'fk_approval_log_usulan'
            columns: ['riwayat_usulan_id']
            isOneToOne: false
            referencedRelation: 'riwayat_usulan'
            referencedColumns: ['riwayat_usulan_id']
          },
        ]
      }
      audit_log: {
        Row: {
          actor_user_id: string
          aksi_at: string
          aksi_audit_id: string | null
          audit_log_id: string
          created_at: string
          created_by: string | null
          keterangan: string | null
          metadata: Json | null
          target_record_id: string
          target_table: string
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          actor_user_id: string
          aksi_at: string
          aksi_audit_id?: string | null
          audit_log_id: string
          created_at?: string
          created_by?: string | null
          keterangan?: string | null
          metadata?: Json | null
          target_record_id: string
          target_table: string
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          actor_user_id?: string
          aksi_at?: string
          aksi_audit_id?: string | null
          audit_log_id?: string
          created_at?: string
          created_by?: string | null
          keterangan?: string | null
          metadata?: Json | null
          target_record_id?: string
          target_table?: string
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_audit_log_actor'
            columns: ['actor_user_id']
            isOneToOne: false
            referencedRelation: 'users'
            referencedColumns: ['user_id']
          },
          {
            foreignKeyName: 'fk_audit_log_aksi'
            columns: ['aksi_audit_id']
            isOneToOne: false
            referencedRelation: 'master_aksi_audit'
            referencedColumns: ['aksi_audit_id']
          },
        ]
      }
      dokumen_pegawai: {
        Row: {
          created_at: string
          created_by: string | null
          dokumen_pegawai_id: string
          file_mime_type: string | null
          file_size_bytes: number
          file_url: string | null
          is_active: boolean
          jenis_dokumen_id: string
          keterangan: string | null
          modul_sumber: string | null
          nama_dokumen: string
          nomor_dokumen: string | null
          object_path: string
          pegawai_id: string
          referensi_record_id: string | null
          status_dokumen_id: string | null
          tanggal_akhir_berlaku: string | null
          tanggal_dokumen: string | null
          tanggal_mulai_berlaku: string | null
          updated_at: string
          updated_by: string | null
          uploaded_at: string
          uploaded_by: string | null
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          dokumen_pegawai_id: string
          file_mime_type?: string | null
          file_size_bytes?: number
          file_url?: string | null
          is_active?: boolean
          jenis_dokumen_id: string
          keterangan?: string | null
          modul_sumber?: string | null
          nama_dokumen: string
          nomor_dokumen?: string | null
          object_path: string
          pegawai_id: string
          referensi_record_id?: string | null
          status_dokumen_id?: string | null
          tanggal_akhir_berlaku?: string | null
          tanggal_dokumen?: string | null
          tanggal_mulai_berlaku?: string | null
          updated_at?: string
          updated_by?: string | null
          uploaded_at?: string
          uploaded_by?: string | null
        }
        Update: {
          created_at?: string
          created_by?: string | null
          dokumen_pegawai_id?: string
          file_mime_type?: string | null
          file_size_bytes?: number
          file_url?: string | null
          is_active?: boolean
          jenis_dokumen_id?: string
          keterangan?: string | null
          modul_sumber?: string | null
          nama_dokumen?: string
          nomor_dokumen?: string | null
          object_path?: string
          pegawai_id?: string
          referensi_record_id?: string | null
          status_dokumen_id?: string | null
          tanggal_akhir_berlaku?: string | null
          tanggal_dokumen?: string | null
          tanggal_mulai_berlaku?: string | null
          updated_at?: string
          updated_by?: string | null
          uploaded_at?: string
          uploaded_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_dokumen_pegawai_jenis'
            columns: ['jenis_dokumen_id']
            isOneToOne: false
            referencedRelation: 'master_jenis_dokumen'
            referencedColumns: ['jenis_dokumen_id']
          },
          {
            foreignKeyName: 'fk_dokumen_pegawai_pegawai'
            columns: ['pegawai_id']
            isOneToOne: false
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
          {
            foreignKeyName: 'fk_dokumen_pegawai_status'
            columns: ['status_dokumen_id']
            isOneToOne: false
            referencedRelation: 'master_status_dokumen'
            referencedColumns: ['status_dokumen_id']
          },
          {
            foreignKeyName: 'fk_dokumen_pegawai_uploaded_by'
            columns: ['uploaded_by']
            isOneToOne: false
            referencedRelation: 'users'
            referencedColumns: ['user_id']
          },
        ]
      }
      master_agama: {
        Row: {
          agama_id: string
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_agama: string
          nama_agama: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          agama_id: string
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_agama: string
          nama_agama: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          agama_id?: string
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_agama?: string
          nama_agama?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_aksi_approval: {
        Row: {
          aksi_approval_id: string
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_aksi_approval: string
          nama_aksi_approval: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          aksi_approval_id: string
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_aksi_approval: string
          nama_aksi_approval: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          aksi_approval_id?: string
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_aksi_approval?: string
          nama_aksi_approval?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_aksi_audit: {
        Row: {
          aksi_audit_id: string
          created_at: string
          created_by: string | null
          is_active: boolean
          kategori_aksi: string | null
          keterangan: string | null
          kode_aksi_audit: string
          nama_aksi_audit: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          aksi_audit_id: string
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          kategori_aksi?: string | null
          keterangan?: string | null
          kode_aksi_audit: string
          nama_aksi_audit: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          aksi_audit_id?: string
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          kategori_aksi?: string | null
          keterangan?: string | null
          kode_aksi_audit?: string
          nama_aksi_audit?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_eselon: {
        Row: {
          created_at: string
          created_by: string | null
          eselon_id: string
          is_active: boolean
          keterangan: string | null
          kode_eselon: string
          nama_eselon: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          eselon_id: string
          is_active?: boolean
          keterangan?: string | null
          kode_eselon: string
          nama_eselon: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          eselon_id?: string
          is_active?: boolean
          keterangan?: string | null
          kode_eselon?: string
          nama_eselon?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_golongan: {
        Row: {
          created_at: string
          created_by: string | null
          golongan_id: string
          is_active: boolean
          keterangan: string | null
          kode_golongan: string
          nama_golongan: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          golongan_id: string
          is_active?: boolean
          keterangan?: string | null
          kode_golongan: string
          nama_golongan: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          golongan_id?: string
          is_active?: boolean
          keterangan?: string | null
          kode_golongan?: string
          nama_golongan?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_jabatan: {
        Row: {
          created_at: string
          created_by: string | null
          eselon_id: string | null
          is_active: boolean
          jabatan_id: string
          jenis_jabatan_id: string | null
          keterangan: string | null
          kode_jabatan: string
          nama_jabatan: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          eselon_id?: string | null
          is_active?: boolean
          jabatan_id: string
          jenis_jabatan_id?: string | null
          keterangan?: string | null
          kode_jabatan: string
          nama_jabatan: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          eselon_id?: string | null
          is_active?: boolean
          jabatan_id?: string
          jenis_jabatan_id?: string | null
          keterangan?: string | null
          kode_jabatan?: string
          nama_jabatan?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: [
          {
            foreignKeyName: 'fk_master_jabatan_eselon'
            columns: ['eselon_id']
            isOneToOne: false
            referencedRelation: 'master_eselon'
            referencedColumns: ['eselon_id']
          },
          {
            foreignKeyName: 'fk_master_jabatan_jenis'
            columns: ['jenis_jabatan_id']
            isOneToOne: false
            referencedRelation: 'master_jenis_jabatan'
            referencedColumns: ['jenis_jabatan_id']
          },
        ]
      }
      master_jenis_dokumen: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          is_wajib: boolean
          jenis_dokumen_id: string
          keterangan: string | null
          kode_jenis_dokumen: string
          modul_sumber_default: string | null
          nama_jenis_dokumen: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          is_wajib?: boolean
          jenis_dokumen_id: string
          keterangan?: string | null
          kode_jenis_dokumen: string
          modul_sumber_default?: string | null
          nama_jenis_dokumen: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          is_wajib?: boolean
          jenis_dokumen_id?: string
          keterangan?: string | null
          kode_jenis_dokumen?: string
          modul_sumber_default?: string | null
          nama_jenis_dokumen?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_jenis_hukuman: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          jenis_hukuman_id: string
          keterangan: string | null
          kode_jenis_hukuman: string
          nama_jenis_hukuman: string
          tingkat_hukuman_id: string | null
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenis_hukuman_id: string
          keterangan?: string | null
          kode_jenis_hukuman: string
          nama_jenis_hukuman: string
          tingkat_hukuman_id?: string | null
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenis_hukuman_id?: string
          keterangan?: string | null
          kode_jenis_hukuman?: string
          nama_jenis_hukuman?: string
          tingkat_hukuman_id?: string | null
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: [
          {
            foreignKeyName: 'fk_master_jenis_hukuman_tingkat'
            columns: ['tingkat_hukuman_id']
            isOneToOne: false
            referencedRelation: 'master_tingkat_hukuman'
            referencedColumns: ['tingkat_hukuman_id']
          },
        ]
      }
      master_jenis_jabatan: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          jenis_jabatan_id: string
          keterangan: string | null
          kode_jenis_jabatan: string
          nama_jenis_jabatan: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenis_jabatan_id: string
          keterangan?: string | null
          kode_jenis_jabatan: string
          nama_jenis_jabatan: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenis_jabatan_id?: string
          keterangan?: string | null
          kode_jenis_jabatan?: string
          nama_jenis_jabatan?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_jenis_kelamin: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          jenis_kelamin_id: string
          keterangan: string | null
          kode_jenis_kelamin: string
          nama_jenis_kelamin: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenis_kelamin_id: string
          keterangan?: string | null
          kode_jenis_kelamin: string
          nama_jenis_kelamin: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenis_kelamin_id?: string
          keterangan?: string | null
          kode_jenis_kelamin?: string
          nama_jenis_kelamin?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_jenis_kenaikan_pangkat: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          jenis_kenaikan_id: string
          keterangan: string | null
          kode_jenis_kenaikan: string
          nama_jenis_kenaikan: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenis_kenaikan_id: string
          keterangan?: string | null
          kode_jenis_kenaikan: string
          nama_jenis_kenaikan: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenis_kenaikan_id?: string
          keterangan?: string | null
          kode_jenis_kenaikan?: string
          nama_jenis_kenaikan?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_jenis_pak: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          jenis_pak_id: string
          keterangan: string | null
          kode_jenis_pak: string
          nama_jenis_pak: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenis_pak_id: string
          keterangan?: string | null
          kode_jenis_pak: string
          nama_jenis_pak: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenis_pak_id?: string
          keterangan?: string | null
          kode_jenis_pak?: string
          nama_jenis_pak?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_jenis_usulan: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          jenis_usulan_id: string
          keterangan: string | null
          kode_jenis_usulan: string
          modul_sumber_default: string | null
          nama_jenis_usulan: string
          requires_approval: boolean
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenis_usulan_id: string
          keterangan?: string | null
          kode_jenis_usulan: string
          modul_sumber_default?: string | null
          nama_jenis_usulan: string
          requires_approval?: boolean
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenis_usulan_id?: string
          keterangan?: string | null
          kode_jenis_usulan?: string
          modul_sumber_default?: string | null
          nama_jenis_usulan?: string
          requires_approval?: boolean
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_jenjang_skp: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          jenjang_id: string
          keterangan: string | null
          kode_jenjang: string
          nama_jenjang: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenjang_id: string
          keterangan?: string | null
          kode_jenjang: string
          nama_jenjang: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          jenjang_id?: string
          keterangan?: string | null
          kode_jenjang?: string
          nama_jenjang?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_kedudukan_hukum: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          kedudukan_hukum_id: string
          keterangan: string | null
          kode_kedudukan_hukum: string
          nama_kedudukan_hukum: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          kedudukan_hukum_id: string
          keterangan?: string | null
          kode_kedudukan_hukum: string
          nama_kedudukan_hukum: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          kedudukan_hukum_id?: string
          keterangan?: string | null
          kode_kedudukan_hukum?: string
          nama_kedudukan_hukum?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_opd: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_opd: string
          nama_opd: string
          opd_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_opd: string
          nama_opd: string
          opd_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_opd?: string
          nama_opd?: string
          opd_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_pangkat: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_pangkat: string
          nama_pangkat: string
          pangkat_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_pangkat: string
          nama_pangkat: string
          pangkat_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_pangkat?: string
          nama_pangkat?: string
          pangkat_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_predikat_skp: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_predikat: string
          nama_predikat: string
          nilai_maksimum: number | null
          nilai_minimum: number | null
          predikat_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_predikat: string
          nama_predikat: string
          nilai_maksimum?: number | null
          nilai_minimum?: number | null
          predikat_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_predikat?: string
          nama_predikat?: string
          nilai_maksimum?: number | null
          nilai_minimum?: number | null
          predikat_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_status_dokumen: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          is_final: boolean
          keterangan: string | null
          kode_status_dokumen: string
          nama_status_dokumen: string
          status_dokumen_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          is_final?: boolean
          keterangan?: string | null
          kode_status_dokumen: string
          nama_status_dokumen: string
          status_dokumen_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          is_final?: boolean
          keterangan?: string | null
          kode_status_dokumen?: string
          nama_status_dokumen?: string
          status_dokumen_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_status_keluarga: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          is_pasangan: boolean
          keterangan: string | null
          kode_status_keluarga: string
          nama_status_keluarga: string
          status_keluarga_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          is_pasangan?: boolean
          keterangan?: string | null
          kode_status_keluarga: string
          nama_status_keluarga: string
          status_keluarga_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          is_pasangan?: boolean
          keterangan?: string | null
          kode_status_keluarga?: string
          nama_status_keluarga?: string
          status_keluarga_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_status_kerja: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_status_kerja: string
          nama_status_kerja: string
          status_kerja_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_status_kerja: string
          nama_status_kerja: string
          status_kerja_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_status_kerja?: string
          nama_status_kerja?: string
          status_kerja_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_status_pegawai: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_status_pegawai: string
          nama_status_pegawai: string
          status_pegawai_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_status_pegawai: string
          nama_status_pegawai: string
          status_pegawai_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_status_pegawai?: string
          nama_status_pegawai?: string
          status_pegawai_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_status_perkawinan: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_status_perkawinan: string
          nama_status_perkawinan: string
          status_perkawinan_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_status_perkawinan: string
          nama_status_perkawinan: string
          status_perkawinan_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_status_perkawinan?: string
          nama_status_perkawinan?: string
          status_perkawinan_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_status_proses_disiplin: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_status_proses: string
          nama_status_proses: string
          status_proses_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_status_proses: string
          nama_status_proses: string
          status_proses_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_status_proses?: string
          nama_status_proses?: string
          status_proses_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_status_studi: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_status_studi: string
          nama_status_studi: string
          status_studi_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_status_studi: string
          nama_status_studi: string
          status_studi_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_status_studi?: string
          nama_status_studi?: string
          status_studi_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_status_usulan: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          is_final: boolean
          keterangan: string | null
          kode_status_usulan: string
          nama_status_usulan: string
          status_usulan_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          is_final?: boolean
          keterangan?: string | null
          kode_status_usulan: string
          nama_status_usulan: string
          status_usulan_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          is_final?: boolean
          keterangan?: string | null
          kode_status_usulan?: string
          nama_status_usulan?: string
          status_usulan_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_tingkat_hukuman: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_tingkat_hukuman: string
          nama_tingkat_hukuman: string
          tingkat_hukuman_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_tingkat_hukuman: string
          nama_tingkat_hukuman: string
          tingkat_hukuman_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_tingkat_hukuman?: string
          nama_tingkat_hukuman?: string
          tingkat_hukuman_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_tingkat_pendidikan: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_tingkat_pendidikan: string
          nama_tingkat_pendidikan: string
          tingkat_pendidikan_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_tingkat_pendidikan: string
          nama_tingkat_pendidikan: string
          tingkat_pendidikan_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_tingkat_pendidikan?: string
          nama_tingkat_pendidikan?: string
          tingkat_pendidikan_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      master_unit_kerja: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          keterangan: string | null
          kode_unit_kerja: string
          nama_unit_kerja: string
          opd_id: string | null
          unit_kerja_id: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_unit_kerja: string
          nama_unit_kerja: string
          opd_id?: string | null
          unit_kerja_id: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          keterangan?: string | null
          kode_unit_kerja?: string
          nama_unit_kerja?: string
          opd_id?: string | null
          unit_kerja_id?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: [
          {
            foreignKeyName: 'fk_master_unit_kerja_opd'
            columns: ['opd_id']
            isOneToOne: false
            referencedRelation: 'master_opd'
            referencedColumns: ['opd_id']
          },
        ]
      }
      modules: {
        Row: {
          created_at: string
          created_by: string | null
          deskripsi: string | null
          icon_name: string | null
          is_active: boolean
          kode_module: string
          module_id: string
          nama_module: string
          updated_at: string
          updated_by: string | null
          urutan: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          deskripsi?: string | null
          icon_name?: string | null
          is_active?: boolean
          kode_module: string
          module_id: string
          nama_module: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          deskripsi?: string | null
          icon_name?: string | null
          is_active?: boolean
          kode_module?: string
          module_id?: string
          nama_module?: string
          updated_at?: string
          updated_by?: string | null
          urutan?: number
        }
        Relationships: []
      }
      pegawai: {
        Row: {
          created_at: string
          created_by: string | null
          is_active: boolean
          kedudukan_hukum_id: string | null
          nama_lengkap: string
          nip: string
          no_karis_karsu: string | null
          no_karpeg: string | null
          no_taspen: string | null
          opd_id: string | null
          pegawai_id: string
          status_kerja_id: string | null
          status_pegawai_id: string
          tmt_cpns: string | null
          tmt_pensiun: string | null
          tmt_pensiun_source: string | null
          tmt_pns: string | null
          unit_kerja_id: string | null
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          kedudukan_hukum_id?: string | null
          nama_lengkap: string
          nip: string
          no_karis_karsu?: string | null
          no_karpeg?: string | null
          no_taspen?: string | null
          opd_id?: string | null
          pegawai_id: string
          status_kerja_id?: string | null
          status_pegawai_id: string
          tmt_cpns?: string | null
          tmt_pensiun?: string | null
          tmt_pensiun_source?: string | null
          tmt_pns?: string | null
          unit_kerja_id?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          created_at?: string
          created_by?: string | null
          is_active?: boolean
          kedudukan_hukum_id?: string | null
          nama_lengkap?: string
          nip?: string
          no_karis_karsu?: string | null
          no_karpeg?: string | null
          no_taspen?: string | null
          opd_id?: string | null
          pegawai_id?: string
          status_kerja_id?: string | null
          status_pegawai_id?: string
          tmt_cpns?: string | null
          tmt_pensiun?: string | null
          tmt_pensiun_source?: string | null
          tmt_pns?: string | null
          unit_kerja_id?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_pegawai_kedudukan_hukum'
            columns: ['kedudukan_hukum_id']
            isOneToOne: false
            referencedRelation: 'master_kedudukan_hukum'
            referencedColumns: ['kedudukan_hukum_id']
          },
          {
            foreignKeyName: 'fk_pegawai_opd'
            columns: ['opd_id']
            isOneToOne: false
            referencedRelation: 'master_opd'
            referencedColumns: ['opd_id']
          },
          {
            foreignKeyName: 'fk_pegawai_status_kerja'
            columns: ['status_kerja_id']
            isOneToOne: false
            referencedRelation: 'master_status_kerja'
            referencedColumns: ['status_kerja_id']
          },
          {
            foreignKeyName: 'fk_pegawai_status_pegawai'
            columns: ['status_pegawai_id']
            isOneToOne: false
            referencedRelation: 'master_status_pegawai'
            referencedColumns: ['status_pegawai_id']
          },
          {
            foreignKeyName: 'fk_pegawai_unit_kerja'
            columns: ['unit_kerja_id']
            isOneToOne: false
            referencedRelation: 'master_unit_kerja'
            referencedColumns: ['unit_kerja_id']
          },
        ]
      }
      pegawai_pribadi: {
        Row: {
          agama_id: string | null
          alamat_domisili: string | null
          alamat_ktp: string | null
          created_at: string
          created_by: string | null
          email_pribadi: string | null
          foto_url: string | null
          jenis_kelamin: string | null
          nik: string | null
          no_bpjs: string | null
          no_hp: string | null
          npwp: string | null
          pegawai_id: string
          pribadi_id: string
          status_perkawinan_id: string | null
          tanggal_lahir: string | null
          tempat_lahir: string | null
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          agama_id?: string | null
          alamat_domisili?: string | null
          alamat_ktp?: string | null
          created_at?: string
          created_by?: string | null
          email_pribadi?: string | null
          foto_url?: string | null
          jenis_kelamin?: string | null
          nik?: string | null
          no_bpjs?: string | null
          no_hp?: string | null
          npwp?: string | null
          pegawai_id: string
          pribadi_id: string
          status_perkawinan_id?: string | null
          tanggal_lahir?: string | null
          tempat_lahir?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          agama_id?: string | null
          alamat_domisili?: string | null
          alamat_ktp?: string | null
          created_at?: string
          created_by?: string | null
          email_pribadi?: string | null
          foto_url?: string | null
          jenis_kelamin?: string | null
          nik?: string | null
          no_bpjs?: string | null
          no_hp?: string | null
          npwp?: string | null
          pegawai_id?: string
          pribadi_id?: string
          status_perkawinan_id?: string | null
          tanggal_lahir?: string | null
          tempat_lahir?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_pegawai_pribadi_agama'
            columns: ['agama_id']
            isOneToOne: false
            referencedRelation: 'master_agama'
            referencedColumns: ['agama_id']
          },
          {
            foreignKeyName: 'fk_pegawai_pribadi_jenis_kelamin'
            columns: ['jenis_kelamin']
            isOneToOne: false
            referencedRelation: 'master_jenis_kelamin'
            referencedColumns: ['jenis_kelamin_id']
          },
          {
            foreignKeyName: 'fk_pegawai_pribadi_pegawai'
            columns: ['pegawai_id']
            isOneToOne: true
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
          {
            foreignKeyName: 'fk_pegawai_pribadi_status_perkawinan'
            columns: ['status_perkawinan_id']
            isOneToOne: false
            referencedRelation: 'master_status_perkawinan'
            referencedColumns: ['status_perkawinan_id']
          },
        ]
      }
      permissions: {
        Row: {
          aksi: string
          created_at: string
          created_by: string | null
          deskripsi: string | null
          is_active: boolean
          kode_permission: string
          module_id: string
          nama_permission: string
          permission_id: string
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          aksi: string
          created_at?: string
          created_by?: string | null
          deskripsi?: string | null
          is_active?: boolean
          kode_permission: string
          module_id: string
          nama_permission: string
          permission_id: string
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          aksi?: string
          created_at?: string
          created_by?: string | null
          deskripsi?: string | null
          is_active?: boolean
          kode_permission?: string
          module_id?: string
          nama_permission?: string
          permission_id?: string
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_permissions_module'
            columns: ['module_id']
            isOneToOne: false
            referencedRelation: 'modules'
            referencedColumns: ['module_id']
          },
        ]
      }
      riwayat_diklat: {
        Row: {
          created_at: string
          created_by: string | null
          jenis_diklat: string | null
          jumlah_jam: number | null
          nama_diklat: string
          no_sertifikat: string | null
          pegawai_id: string
          penyelenggara: string | null
          riwayat_diklat_id: string
          tahun: number | null
          tanggal_mulai: string | null
          tanggal_selesai: string | null
          tanggal_sertifikat: string | null
          tempat: string | null
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          jenis_diklat?: string | null
          jumlah_jam?: number | null
          nama_diklat: string
          no_sertifikat?: string | null
          pegawai_id: string
          penyelenggara?: string | null
          riwayat_diklat_id: string
          tahun?: number | null
          tanggal_mulai?: string | null
          tanggal_selesai?: string | null
          tanggal_sertifikat?: string | null
          tempat?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          created_at?: string
          created_by?: string | null
          jenis_diklat?: string | null
          jumlah_jam?: number | null
          nama_diklat?: string
          no_sertifikat?: string | null
          pegawai_id?: string
          penyelenggara?: string | null
          riwayat_diklat_id?: string
          tahun?: number | null
          tanggal_mulai?: string | null
          tanggal_selesai?: string | null
          tanggal_sertifikat?: string | null
          tempat?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_riwayat_diklat_pegawai'
            columns: ['pegawai_id']
            isOneToOne: false
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
        ]
      }
      riwayat_disiplin: {
        Row: {
          alasan_hukuman: string | null
          created_at: string
          created_by: string | null
          is_aktif: boolean
          jenis_hukuman_id: string | null
          keterangan: string | null
          no_bap: string | null
          no_sk_hukuman: string | null
          no_surat_panggilan: string | null
          pegawai_id: string
          riwayat_disiplin_id: string
          status_proses_id: string | null
          tanggal_bap: string | null
          tanggal_panggilan: string | null
          tanggal_sk_hukuman: string | null
          tingkat_hukuman_id: string | null
          tmt_akhir_hukuman: string | null
          tmt_hukuman: string | null
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          alasan_hukuman?: string | null
          created_at?: string
          created_by?: string | null
          is_aktif: boolean
          jenis_hukuman_id?: string | null
          keterangan?: string | null
          no_bap?: string | null
          no_sk_hukuman?: string | null
          no_surat_panggilan?: string | null
          pegawai_id: string
          riwayat_disiplin_id: string
          status_proses_id?: string | null
          tanggal_bap?: string | null
          tanggal_panggilan?: string | null
          tanggal_sk_hukuman?: string | null
          tingkat_hukuman_id?: string | null
          tmt_akhir_hukuman?: string | null
          tmt_hukuman?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          alasan_hukuman?: string | null
          created_at?: string
          created_by?: string | null
          is_aktif?: boolean
          jenis_hukuman_id?: string | null
          keterangan?: string | null
          no_bap?: string | null
          no_sk_hukuman?: string | null
          no_surat_panggilan?: string | null
          pegawai_id?: string
          riwayat_disiplin_id?: string
          status_proses_id?: string | null
          tanggal_bap?: string | null
          tanggal_panggilan?: string | null
          tanggal_sk_hukuman?: string | null
          tingkat_hukuman_id?: string | null
          tmt_akhir_hukuman?: string | null
          tmt_hukuman?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_riwayat_disiplin_jenis'
            columns: ['jenis_hukuman_id']
            isOneToOne: false
            referencedRelation: 'master_jenis_hukuman'
            referencedColumns: ['jenis_hukuman_id']
          },
          {
            foreignKeyName: 'fk_riwayat_disiplin_pegawai'
            columns: ['pegawai_id']
            isOneToOne: false
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
          {
            foreignKeyName: 'fk_riwayat_disiplin_status_proses'
            columns: ['status_proses_id']
            isOneToOne: false
            referencedRelation: 'master_status_proses_disiplin'
            referencedColumns: ['status_proses_id']
          },
          {
            foreignKeyName: 'fk_riwayat_disiplin_tingkat'
            columns: ['tingkat_hukuman_id']
            isOneToOne: false
            referencedRelation: 'master_tingkat_hukuman'
            referencedColumns: ['tingkat_hukuman_id']
          },
        ]
      }
      riwayat_jabatan: {
        Row: {
          created_at: string
          created_by: string | null
          eselon_id: string | null
          is_current: boolean
          is_definitif: boolean | null
          is_plh: boolean | null
          is_plt: boolean | null
          jabatan_id: string
          jenis_jabatan_id: string | null
          kelas_jabatan: number | null
          keterangan: string | null
          no_sk: string | null
          opd_id: string | null
          pegawai_id: string
          pejabat_penetap: string | null
          riwayat_jabatan_id: string
          tanggal_sk: string | null
          tmt_akhir_jabatan: string | null
          tmt_jabatan: string
          unit_kerja_id: string | null
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          eselon_id?: string | null
          is_current: boolean
          is_definitif?: boolean | null
          is_plh?: boolean | null
          is_plt?: boolean | null
          jabatan_id: string
          jenis_jabatan_id?: string | null
          kelas_jabatan?: number | null
          keterangan?: string | null
          no_sk?: string | null
          opd_id?: string | null
          pegawai_id: string
          pejabat_penetap?: string | null
          riwayat_jabatan_id: string
          tanggal_sk?: string | null
          tmt_akhir_jabatan?: string | null
          tmt_jabatan: string
          unit_kerja_id?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          created_at?: string
          created_by?: string | null
          eselon_id?: string | null
          is_current?: boolean
          is_definitif?: boolean | null
          is_plh?: boolean | null
          is_plt?: boolean | null
          jabatan_id?: string
          jenis_jabatan_id?: string | null
          kelas_jabatan?: number | null
          keterangan?: string | null
          no_sk?: string | null
          opd_id?: string | null
          pegawai_id?: string
          pejabat_penetap?: string | null
          riwayat_jabatan_id?: string
          tanggal_sk?: string | null
          tmt_akhir_jabatan?: string | null
          tmt_jabatan?: string
          unit_kerja_id?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_riwayat_jabatan_eselon'
            columns: ['eselon_id']
            isOneToOne: false
            referencedRelation: 'master_eselon'
            referencedColumns: ['eselon_id']
          },
          {
            foreignKeyName: 'fk_riwayat_jabatan_jabatan'
            columns: ['jabatan_id']
            isOneToOne: false
            referencedRelation: 'master_jabatan'
            referencedColumns: ['jabatan_id']
          },
          {
            foreignKeyName: 'fk_riwayat_jabatan_jenis'
            columns: ['jenis_jabatan_id']
            isOneToOne: false
            referencedRelation: 'master_jenis_jabatan'
            referencedColumns: ['jenis_jabatan_id']
          },
          {
            foreignKeyName: 'fk_riwayat_jabatan_opd'
            columns: ['opd_id']
            isOneToOne: false
            referencedRelation: 'master_opd'
            referencedColumns: ['opd_id']
          },
          {
            foreignKeyName: 'fk_riwayat_jabatan_pegawai'
            columns: ['pegawai_id']
            isOneToOne: false
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
          {
            foreignKeyName: 'fk_riwayat_jabatan_unit_kerja'
            columns: ['unit_kerja_id']
            isOneToOne: false
            referencedRelation: 'master_unit_kerja'
            referencedColumns: ['unit_kerja_id']
          },
        ]
      }
      riwayat_keluarga: {
        Row: {
          agama_id: string | null
          created_at: string
          created_by: string | null
          gelar_belakang: string | null
          gelar_depan: string | null
          is_current: boolean | null
          is_pasangan: boolean
          jenis_kelamin: string | null
          keluarga_id: string
          keterangan: string | null
          nama_keluarga: string
          nik: string | null
          no_akta: string | null
          pegawai_id: string
          pekerjaan: string | null
          pendidikan_id: string | null
          status_hidup: string | null
          status_keluarga_id: string
          status_tanggungan: boolean | null
          tanggal_cerai: string | null
          tanggal_lahir: string | null
          tanggal_menikah: string | null
          tanggal_meninggal: string | null
          tempat_lahir: string | null
          updated_at: string
          updated_by: string | null
          urutan_anak: number | null
        }
        Insert: {
          agama_id?: string | null
          created_at?: string
          created_by?: string | null
          gelar_belakang?: string | null
          gelar_depan?: string | null
          is_current?: boolean | null
          is_pasangan?: boolean
          jenis_kelamin?: string | null
          keluarga_id: string
          keterangan?: string | null
          nama_keluarga: string
          nik?: string | null
          no_akta?: string | null
          pegawai_id: string
          pekerjaan?: string | null
          pendidikan_id?: string | null
          status_hidup?: string | null
          status_keluarga_id: string
          status_tanggungan?: boolean | null
          tanggal_cerai?: string | null
          tanggal_lahir?: string | null
          tanggal_menikah?: string | null
          tanggal_meninggal?: string | null
          tempat_lahir?: string | null
          updated_at?: string
          updated_by?: string | null
          urutan_anak?: number | null
        }
        Update: {
          agama_id?: string | null
          created_at?: string
          created_by?: string | null
          gelar_belakang?: string | null
          gelar_depan?: string | null
          is_current?: boolean | null
          is_pasangan?: boolean
          jenis_kelamin?: string | null
          keluarga_id?: string
          keterangan?: string | null
          nama_keluarga?: string
          nik?: string | null
          no_akta?: string | null
          pegawai_id?: string
          pekerjaan?: string | null
          pendidikan_id?: string | null
          status_hidup?: string | null
          status_keluarga_id?: string
          status_tanggungan?: boolean | null
          tanggal_cerai?: string | null
          tanggal_lahir?: string | null
          tanggal_menikah?: string | null
          tanggal_meninggal?: string | null
          tempat_lahir?: string | null
          updated_at?: string
          updated_by?: string | null
          urutan_anak?: number | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_riwayat_keluarga_agama'
            columns: ['agama_id']
            isOneToOne: false
            referencedRelation: 'master_agama'
            referencedColumns: ['agama_id']
          },
          {
            foreignKeyName: 'fk_riwayat_keluarga_jenis_kelamin'
            columns: ['jenis_kelamin']
            isOneToOne: false
            referencedRelation: 'master_jenis_kelamin'
            referencedColumns: ['jenis_kelamin_id']
          },
          {
            foreignKeyName: 'fk_riwayat_keluarga_pegawai'
            columns: ['pegawai_id']
            isOneToOne: false
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
          {
            foreignKeyName: 'fk_riwayat_keluarga_pendidikan'
            columns: ['pendidikan_id']
            isOneToOne: false
            referencedRelation: 'master_tingkat_pendidikan'
            referencedColumns: ['tingkat_pendidikan_id']
          },
          {
            foreignKeyName: 'fk_riwayat_keluarga_status'
            columns: ['status_keluarga_id']
            isOneToOne: false
            referencedRelation: 'master_status_keluarga'
            referencedColumns: ['status_keluarga_id']
          },
        ]
      }
      riwayat_kgb: {
        Row: {
          created_at: string
          created_by: string | null
          gaji_pokok_baru: number
          gaji_pokok_lama: number | null
          is_terakhir: boolean
          keterangan: string | null
          masa_kerja_bulan: number | null
          masa_kerja_tahun: number | null
          no_sk_kgb: string | null
          pegawai_id: string
          riwayat_kgb_id: string
          tmt_kgb: string
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          gaji_pokok_baru: number
          gaji_pokok_lama?: number | null
          is_terakhir: boolean
          keterangan?: string | null
          masa_kerja_bulan?: number | null
          masa_kerja_tahun?: number | null
          no_sk_kgb?: string | null
          pegawai_id: string
          riwayat_kgb_id: string
          tmt_kgb: string
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          created_at?: string
          created_by?: string | null
          gaji_pokok_baru?: number
          gaji_pokok_lama?: number | null
          is_terakhir?: boolean
          keterangan?: string | null
          masa_kerja_bulan?: number | null
          masa_kerja_tahun?: number | null
          no_sk_kgb?: string | null
          pegawai_id?: string
          riwayat_kgb_id?: string
          tmt_kgb?: string
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_riwayat_kgb_pegawai'
            columns: ['pegawai_id']
            isOneToOne: false
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
        ]
      }
      riwayat_pak: {
        Row: {
          ak_dasar_baru: number | null
          ak_dasar_lama: number | null
          ak_dasar_total: number | null
          ak_jf_baru: number | null
          ak_jf_lama: number | null
          ak_jf_total: number | null
          ak_konversi_baru: number | null
          ak_konversi_lama: number | null
          ak_konversi_total: number | null
          ak_kumulatif_total: number
          ak_peningkatan_baru: number | null
          ak_peningkatan_lama: number | null
          ak_peningkatan_total: number | null
          ak_penyesuaian_baru: number | null
          ak_penyesuaian_lama: number | null
          ak_penyesuaian_total: number | null
          created_at: string
          created_by: string | null
          is_terakhir: boolean
          jenis_pak_id: string | null
          keterangan: string | null
          no_sk_pak: string | null
          pegawai_id: string
          pejabat_penetap: string | null
          periode_akhir: string | null
          periode_awal: string | null
          riwayat_pak_id: string
          selisih_jenjang: number | null
          selisih_pangkat: number | null
          status_dokumen_id: string | null
          tanggal_sk_pak: string | null
          target_jenjang_id: string | null
          target_pangkat_id: string | null
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          ak_dasar_baru?: number | null
          ak_dasar_lama?: number | null
          ak_dasar_total?: number | null
          ak_jf_baru?: number | null
          ak_jf_lama?: number | null
          ak_jf_total?: number | null
          ak_konversi_baru?: number | null
          ak_konversi_lama?: number | null
          ak_konversi_total?: number | null
          ak_kumulatif_total: number
          ak_peningkatan_baru?: number | null
          ak_peningkatan_lama?: number | null
          ak_peningkatan_total?: number | null
          ak_penyesuaian_baru?: number | null
          ak_penyesuaian_lama?: number | null
          ak_penyesuaian_total?: number | null
          created_at?: string
          created_by?: string | null
          is_terakhir: boolean
          jenis_pak_id?: string | null
          keterangan?: string | null
          no_sk_pak?: string | null
          pegawai_id: string
          pejabat_penetap?: string | null
          periode_akhir?: string | null
          periode_awal?: string | null
          riwayat_pak_id: string
          selisih_jenjang?: number | null
          selisih_pangkat?: number | null
          status_dokumen_id?: string | null
          tanggal_sk_pak?: string | null
          target_jenjang_id?: string | null
          target_pangkat_id?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          ak_dasar_baru?: number | null
          ak_dasar_lama?: number | null
          ak_dasar_total?: number | null
          ak_jf_baru?: number | null
          ak_jf_lama?: number | null
          ak_jf_total?: number | null
          ak_konversi_baru?: number | null
          ak_konversi_lama?: number | null
          ak_konversi_total?: number | null
          ak_kumulatif_total?: number
          ak_peningkatan_baru?: number | null
          ak_peningkatan_lama?: number | null
          ak_peningkatan_total?: number | null
          ak_penyesuaian_baru?: number | null
          ak_penyesuaian_lama?: number | null
          ak_penyesuaian_total?: number | null
          created_at?: string
          created_by?: string | null
          is_terakhir?: boolean
          jenis_pak_id?: string | null
          keterangan?: string | null
          no_sk_pak?: string | null
          pegawai_id?: string
          pejabat_penetap?: string | null
          periode_akhir?: string | null
          periode_awal?: string | null
          riwayat_pak_id?: string
          selisih_jenjang?: number | null
          selisih_pangkat?: number | null
          status_dokumen_id?: string | null
          tanggal_sk_pak?: string | null
          target_jenjang_id?: string | null
          target_pangkat_id?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_riwayat_pak_jenis'
            columns: ['jenis_pak_id']
            isOneToOne: false
            referencedRelation: 'master_jenis_pak'
            referencedColumns: ['jenis_pak_id']
          },
          {
            foreignKeyName: 'fk_riwayat_pak_pegawai'
            columns: ['pegawai_id']
            isOneToOne: false
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
          {
            foreignKeyName: 'fk_riwayat_pak_status_dokumen'
            columns: ['status_dokumen_id']
            isOneToOne: false
            referencedRelation: 'master_status_dokumen'
            referencedColumns: ['status_dokumen_id']
          },
          {
            foreignKeyName: 'fk_riwayat_pak_target_jenjang'
            columns: ['target_jenjang_id']
            isOneToOne: false
            referencedRelation: 'master_jenis_jabatan'
            referencedColumns: ['jenis_jabatan_id']
          },
          {
            foreignKeyName: 'fk_riwayat_pak_target_pangkat'
            columns: ['target_pangkat_id']
            isOneToOne: false
            referencedRelation: 'master_pangkat'
            referencedColumns: ['pangkat_id']
          },
        ]
      }
      riwayat_pangkat_golongan: {
        Row: {
          created_at: string
          created_by: string | null
          gaji_pokok: number | null
          golongan_id: string
          is_current: boolean
          jenis_kenaikan_id: string | null
          keterangan: string | null
          masa_kerja_bulan: number | null
          masa_kerja_source: string | null
          masa_kerja_tahun: number | null
          no_sk: string | null
          pangkat_id: string
          pegawai_id: string
          pejabat_penetap: string | null
          riwayat_pangkat_id: string
          tanggal_sk: string | null
          tmt_pangkat: string
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          gaji_pokok?: number | null
          golongan_id: string
          is_current: boolean
          jenis_kenaikan_id?: string | null
          keterangan?: string | null
          masa_kerja_bulan?: number | null
          masa_kerja_source?: string | null
          masa_kerja_tahun?: number | null
          no_sk?: string | null
          pangkat_id: string
          pegawai_id: string
          pejabat_penetap?: string | null
          riwayat_pangkat_id: string
          tanggal_sk?: string | null
          tmt_pangkat: string
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          created_at?: string
          created_by?: string | null
          gaji_pokok?: number | null
          golongan_id?: string
          is_current?: boolean
          jenis_kenaikan_id?: string | null
          keterangan?: string | null
          masa_kerja_bulan?: number | null
          masa_kerja_source?: string | null
          masa_kerja_tahun?: number | null
          no_sk?: string | null
          pangkat_id?: string
          pegawai_id?: string
          pejabat_penetap?: string | null
          riwayat_pangkat_id?: string
          tanggal_sk?: string | null
          tmt_pangkat?: string
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_riwayat_pangkat_golongan'
            columns: ['golongan_id']
            isOneToOne: false
            referencedRelation: 'master_golongan'
            referencedColumns: ['golongan_id']
          },
          {
            foreignKeyName: 'fk_riwayat_pangkat_jenis_kenaikan'
            columns: ['jenis_kenaikan_id']
            isOneToOne: false
            referencedRelation: 'master_jenis_kenaikan_pangkat'
            referencedColumns: ['jenis_kenaikan_id']
          },
          {
            foreignKeyName: 'fk_riwayat_pangkat_pangkat'
            columns: ['pangkat_id']
            isOneToOne: false
            referencedRelation: 'master_pangkat'
            referencedColumns: ['pangkat_id']
          },
          {
            foreignKeyName: 'fk_riwayat_pangkat_pegawai'
            columns: ['pegawai_id']
            isOneToOne: false
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
        ]
      }
      riwayat_pendidikan: {
        Row: {
          created_at: string
          created_by: string | null
          gelar_belakang: string | null
          gelar_depan: string | null
          institusi_pendidikan: string | null
          is_terakhir: boolean
          jurusan_nama: string | null
          keterangan: string | null
          keterangan_perjanjian: string | null
          no_ijazah: string | null
          no_sk_pemberhentian: string | null
          no_sk_pencantuman_gelar: string | null
          no_sk_tubel: string | null
          pegawai_id: string
          riwayat_pendidikan_id: string
          status_studi_id: string | null
          tanggal_ijazah: string | null
          tanggal_sk_tubel: string | null
          tingkat_pendidikan_id: string
          tmt_tubel_akhir: string | null
          tmt_tubel_awal: string | null
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          gelar_belakang?: string | null
          gelar_depan?: string | null
          institusi_pendidikan?: string | null
          is_terakhir: boolean
          jurusan_nama?: string | null
          keterangan?: string | null
          keterangan_perjanjian?: string | null
          no_ijazah?: string | null
          no_sk_pemberhentian?: string | null
          no_sk_pencantuman_gelar?: string | null
          no_sk_tubel?: string | null
          pegawai_id: string
          riwayat_pendidikan_id: string
          status_studi_id?: string | null
          tanggal_ijazah?: string | null
          tanggal_sk_tubel?: string | null
          tingkat_pendidikan_id: string
          tmt_tubel_akhir?: string | null
          tmt_tubel_awal?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          created_at?: string
          created_by?: string | null
          gelar_belakang?: string | null
          gelar_depan?: string | null
          institusi_pendidikan?: string | null
          is_terakhir?: boolean
          jurusan_nama?: string | null
          keterangan?: string | null
          keterangan_perjanjian?: string | null
          no_ijazah?: string | null
          no_sk_pemberhentian?: string | null
          no_sk_pencantuman_gelar?: string | null
          no_sk_tubel?: string | null
          pegawai_id?: string
          riwayat_pendidikan_id?: string
          status_studi_id?: string | null
          tanggal_ijazah?: string | null
          tanggal_sk_tubel?: string | null
          tingkat_pendidikan_id?: string
          tmt_tubel_akhir?: string | null
          tmt_tubel_awal?: string | null
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_riwayat_pendidikan_pegawai'
            columns: ['pegawai_id']
            isOneToOne: false
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
          {
            foreignKeyName: 'fk_riwayat_pendidikan_studi'
            columns: ['status_studi_id']
            isOneToOne: false
            referencedRelation: 'master_status_studi'
            referencedColumns: ['status_studi_id']
          },
          {
            foreignKeyName: 'fk_riwayat_pendidikan_tingkat'
            columns: ['tingkat_pendidikan_id']
            isOneToOne: false
            referencedRelation: 'master_tingkat_pendidikan'
            referencedColumns: ['tingkat_pendidikan_id']
          },
        ]
      }
      riwayat_skp: {
        Row: {
          angka_kredit: number | null
          created_at: string
          created_by: string | null
          is_terakhir: boolean
          jenjang_id: string | null
          jumlah_bulan_penilaian: number | null
          keterangan: string | null
          koefisien_dasar: number | null
          nilai_kinerja: number
          pegawai_id: string
          periode_akhir: string | null
          periode_awal: string | null
          predikat_id: string | null
          riwayat_skp_id: string
          tahun: number
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          angka_kredit?: number | null
          created_at?: string
          created_by?: string | null
          is_terakhir: boolean
          jenjang_id?: string | null
          jumlah_bulan_penilaian?: number | null
          keterangan?: string | null
          koefisien_dasar?: number | null
          nilai_kinerja: number
          pegawai_id: string
          periode_akhir?: string | null
          periode_awal?: string | null
          predikat_id?: string | null
          riwayat_skp_id: string
          tahun: number
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          angka_kredit?: number | null
          created_at?: string
          created_by?: string | null
          is_terakhir?: boolean
          jenjang_id?: string | null
          jumlah_bulan_penilaian?: number | null
          keterangan?: string | null
          koefisien_dasar?: number | null
          nilai_kinerja?: number
          pegawai_id?: string
          periode_akhir?: string | null
          periode_awal?: string | null
          predikat_id?: string | null
          riwayat_skp_id?: string
          tahun?: number
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_riwayat_skp_jenjang'
            columns: ['jenjang_id']
            isOneToOne: false
            referencedRelation: 'master_jenjang_skp'
            referencedColumns: ['jenjang_id']
          },
          {
            foreignKeyName: 'fk_riwayat_skp_pegawai'
            columns: ['pegawai_id']
            isOneToOne: false
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
          {
            foreignKeyName: 'fk_riwayat_skp_predikat'
            columns: ['predikat_id']
            isOneToOne: false
            referencedRelation: 'master_predikat_skp'
            referencedColumns: ['predikat_id']
          },
        ]
      }
      riwayat_usulan: {
        Row: {
          catatan_verifikator: string | null
          created_at: string
          created_by: string | null
          is_aktif: boolean
          jenis_usulan_id: string
          keterangan: string | null
          modul_sumber: string
          pegawai_id: string
          periode_bulan: number | null
          periode_tahun: number | null
          referensi_record_id: string
          riwayat_usulan_id: string
          status_usulan_id: string
          tanggal_status: string | null
          tanggal_usulan: string
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          catatan_verifikator?: string | null
          created_at?: string
          created_by?: string | null
          is_aktif: boolean
          jenis_usulan_id: string
          keterangan?: string | null
          modul_sumber: string
          pegawai_id: string
          periode_bulan?: number | null
          periode_tahun?: number | null
          referensi_record_id: string
          riwayat_usulan_id: string
          status_usulan_id: string
          tanggal_status?: string | null
          tanggal_usulan: string
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          catatan_verifikator?: string | null
          created_at?: string
          created_by?: string | null
          is_aktif?: boolean
          jenis_usulan_id?: string
          keterangan?: string | null
          modul_sumber?: string
          pegawai_id?: string
          periode_bulan?: number | null
          periode_tahun?: number | null
          referensi_record_id?: string
          riwayat_usulan_id?: string
          status_usulan_id?: string
          tanggal_status?: string | null
          tanggal_usulan?: string
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: [
          {
            foreignKeyName: 'fk_riwayat_usulan_jenis'
            columns: ['jenis_usulan_id']
            isOneToOne: false
            referencedRelation: 'master_jenis_usulan'
            referencedColumns: ['jenis_usulan_id']
          },
          {
            foreignKeyName: 'fk_riwayat_usulan_pegawai'
            columns: ['pegawai_id']
            isOneToOne: false
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
          {
            foreignKeyName: 'fk_riwayat_usulan_status'
            columns: ['status_usulan_id']
            isOneToOne: false
            referencedRelation: 'master_status_usulan'
            referencedColumns: ['status_usulan_id']
          },
        ]
      }
      roles: {
        Row: {
          created_at: string
          created_by: string | null
          deskripsi: string | null
          is_active: boolean
          is_system: boolean
          kode_role: string
          level: number
          nama_role: string
          role_id: string
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          deskripsi?: string | null
          is_active?: boolean
          is_system?: boolean
          kode_role: string
          level?: number
          nama_role: string
          role_id: string
          updated_at?: string
          updated_by?: string | null
        }
        Update: {
          created_at?: string
          created_by?: string | null
          deskripsi?: string | null
          is_active?: boolean
          is_system?: boolean
          kode_role?: string
          level?: number
          nama_role?: string
          role_id?: string
          updated_at?: string
          updated_by?: string | null
        }
        Relationships: []
      }
      role_permissions: {
        Row: {
          created_at: string
          granted_at: string
          granted_by: string | null
          is_active: boolean
          permission_id: string
          role_id: string
          role_permission_id: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          granted_at?: string
          granted_by?: string | null
          is_active?: boolean
          permission_id: string
          role_id: string
          role_permission_id: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          granted_at?: string
          granted_by?: string | null
          is_active?: boolean
          permission_id?: string
          role_id?: string
          role_permission_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: 'fk_role_permissions_role'
            columns: ['role_id']
            isOneToOne: false
            referencedRelation: 'roles'
            referencedColumns: ['role_id']
          },
          {
            foreignKeyName: 'fk_role_permissions_permission'
            columns: ['permission_id']
            isOneToOne: false
            referencedRelation: 'permissions'
            referencedColumns: ['permission_id']
          },
        ]
      }
      user_roles: {
        Row: {
          assigned_at: string
          created_at: string
          created_by: string | null
          expired_at: string | null
          is_active: boolean
          role_id: string
          status: string
          updated_at: string
          updated_by: string | null
          user_id: string
          user_role_id: string
        }
        Insert: {
          assigned_at?: string
          created_at?: string
          created_by?: string | null
          expired_at?: string | null
          is_active?: boolean
          role_id: string
          status?: string
          updated_at?: string
          updated_by?: string | null
          user_id: string
          user_role_id: string
        }
        Update: {
          assigned_at?: string
          created_at?: string
          created_by?: string | null
          expired_at?: string | null
          is_active?: boolean
          role_id?: string
          status?: string
          updated_at?: string
          updated_by?: string | null
          user_id?: string
          user_role_id?: string
        }
        Relationships: [
          {
            foreignKeyName: 'fk_user_roles_role'
            columns: ['role_id']
            isOneToOne: false
            referencedRelation: 'roles'
            referencedColumns: ['role_id']
          },
          {
            foreignKeyName: 'fk_user_roles_user'
            columns: ['user_id']
            isOneToOne: false
            referencedRelation: 'users'
            referencedColumns: ['user_id']
          },
        ]
      }
      users: {
        Row: {
          auth_user_id: string | null
          created_at: string
          created_by: string | null
          email_login: string | null
          failed_login_count: number
          is_active: boolean
          is_locked: boolean
          last_login_at: string | null
          password_changed_at: string | null
          password_hash: string | null
          pegawai_id: string | null
          updated_at: string
          updated_by: string | null
          user_id: string
          username: string
        }
        Insert: {
          auth_user_id?: string | null
          created_at?: string
          created_by?: string | null
          email_login?: string | null
          failed_login_count?: number
          is_active?: boolean
          is_locked?: boolean
          last_login_at?: string | null
          password_changed_at?: string | null
          password_hash?: string | null
          pegawai_id?: string | null
          updated_at?: string
          updated_by?: string | null
          user_id: string
          username: string
        }
        Update: {
          auth_user_id?: string | null
          created_at?: string
          created_by?: string | null
          email_login?: string | null
          failed_login_count?: number
          is_active?: boolean
          is_locked?: boolean
          last_login_at?: string | null
          password_changed_at?: string | null
          password_hash?: string | null
          pegawai_id?: string | null
          updated_at?: string
          updated_by?: string | null
          user_id?: string
          username?: string
        }
        Relationships: [
          {
            foreignKeyName: 'fk_users_pegawai'
            columns: ['pegawai_id']
            isOneToOne: true
            referencedRelation: 'pegawai'
            referencedColumns: ['pegawai_id']
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, '__InternalSupabase'>

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, 'public'>]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema['Tables'] & DefaultSchema['Views'])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables'] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Views'])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables'] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Views'])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema['Tables'] &
        DefaultSchema['Views'])
    ? (DefaultSchema['Tables'] &
        DefaultSchema['Views'])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema['Tables']
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables']
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables'][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema['Tables']
    ? DefaultSchema['Tables'][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema['Tables']
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables']
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables'][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema['Tables']
    ? DefaultSchema['Tables'][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema['Enums']
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions['schema']]['Enums']
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions['schema']]['Enums'][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema['Enums']
    ? DefaultSchema['Enums'][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema['CompositeTypes']
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions['schema']]['CompositeTypes']
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions['schema']]['CompositeTypes'][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema['CompositeTypes']
    ? DefaultSchema['CompositeTypes'][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  graphql_public: {
    Enums: {},
  },
  public: {
    Enums: {},
  },
} as const
