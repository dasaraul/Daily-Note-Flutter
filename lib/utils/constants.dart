import 'package:flutter/material.dart';

class AppColors {
  // Palette dari warna yang diminta
  static Color primary = const Color(0xFF66545E);    // #66545e (102,84,94)
  static Color surface = const Color(0xFFA39193);    // #a39193 (163,145,147)
  static Color tertiary = const Color(0xFFAA6F73);   // #aa6f73 (170,111,115)
  static Color secondary = const Color(0xFFEEA990);  // #eea990 (238,169,144)
  static Color background = const Color(0xFFF6E0B5); // #f6e0b5 (246,224,181)
}

class AppStrings {
  static const String appName = "Catatan Harian";
  static const String developerName = "Tri Devi";
  static const String whatsappContact = "wa.me/6281315779992";
  static const String copyright = "© 2025 Develop By Tri Devi";
  
  // Home Screen
  static const String emptyNotes = "Belum ada catatan. Tap + untuk menambah catatan baru.";
  static const String search = "Cari catatan...";
  static const String confirm = "Konfirmasi";
  static const String deleteConfirm = "Apakah Anda yakin ingin menghapus catatan ini?";
  static const String yes = "Ya";
  static const String no = "Tidak";
  
  // Form
  static const String titleHint = "Judul Catatan";
  static const String contentHint = "Isi Catatan";
  static const String requiredField = "Bagian ini wajib diisi";
  static const String save = "Simpan";
  static const String cancel = "Batal";
  static const String edit = "Edit";
  static const String delete = "Hapus";
  static const String add = "Tambah Catatan";
  
  // Loading
  static const String loading = "Memuat...";
  static const String saving = "Menyimpan...";
  static const String deleting = "Menghapus...";
}