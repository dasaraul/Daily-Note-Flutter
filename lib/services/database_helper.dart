import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:catatan_harian/models/catatan_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'catatan_harian.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE catatan(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT NOT NULL,
        isi TEXT NOT NULL,
        tanggal TEXT NOT NULL
      )
    ''');
  }

  // Tambah catatan baru
  Future<int> tambahCatatan(Catatan catatan) async {
    Database db = await instance.database;
    return await db.insert('catatan', catatan.toMap());
  }

  // Ambil semua catatan
  Future<List<Catatan>> ambilSemuaCatatan() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('catatan', orderBy: 'id DESC');
    return List.generate(maps.length, (i) {
      return Catatan.fromMap(maps[i]);
    });
  }

  // Ambil catatan berdasarkan ID
  Future<Catatan?> ambilCatatanById(int id) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Catatan.fromMap(maps.first);
    }
    return null;
  }

  // Perbarui catatan
  Future<int> perbaruiCatatan(Catatan catatan) async {
    Database db = await instance.database;
    return await db.update(
      'catatan',
      catatan.toMap(),
      where: 'id = ?',
      whereArgs: [catatan.id],
    );
  }

  // Hapus catatan
  Future<int> hapusCatatan(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Cari catatan berdasarkan kata kunci
  Future<List<Catatan>> cariCatatan(String keyword) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'catatan',
      where: 'judul LIKE ? OR isi LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
      orderBy: 'id DESC',
    );
    
    return List.generate(maps.length, (i) {
      return Catatan.fromMap(maps[i]);
    });
  }
}