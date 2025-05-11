import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;

  static Database? _dbHelper;

  DbHelper._internal();

  // Inicializa la base de datos
  Future<Database> get database async {
    if (_dbHelper != null) return _dbHelper!;
    _dbHelper = await _initDatabase();
    return _dbHelper!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Crea la tabla
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        lastName TEXT,
        status TEXT,
        age TEXT,
        bornCountry TEXT,
        lastSeen TEXT,
        placeLastSeen TEXT,
        tez TEXT,
        sangre TEXT,
        contextura TEXT,
        estatura TEXT,
        cabello TEXT,
        boca TEXT,
        ojos TEXT,
        nariz TEXT,
        alertNoteUrl TEXT,
        image1 TEXT
      )
    ''');
  }

  // Agregar un report
  Future<int> addReport({
    required String name,
    required String lastName,
    required String status,
    required String age,
    required String bornCountry,
    required String lastSeen,
    required String placeLastSeen,
    String? tez,
    String? sangre,
    String? contextura,
    String? estatura,
    String? cabello,
    String? boca,
    String? ojos,
    String? nariz,
    required String alertNoteUrl,
    String? image1,
  }) async {
    final db = await database;
    return await db.insert(
      'reports',
      {
        'name': name,
        'lastName': lastName,
        'status': status,
        'age': age,
        'bornCountry': bornCountry,
        'lastSeen': lastSeen,
        'placeLastSeen': placeLastSeen,
        'tez': tez,
        'sangre': sangre,
        'contextura': contextura,
        'estatura': estatura,
        'cabello': cabello,
        'boca': boca,
        'ojos': ojos,
        'nariz': nariz,
        'alertNoteUrl': alertNoteUrl,
        'image1': image1,
      },
    );
  }

  // Obtener todos los reportes
  Future<List<Map<String, dynamic>>> getReports() async {
    final db = await database;
    return await db.query('reports');
  }

// Actualizar un reporte
  Future<int> updateReport({
    required int id,
    required String name,
    required String lastName,
    required String status,
    required String age,
    required String bornCountry,
    required String lastSeen,
    required String placeLastSeen,
    String? tez,
    String? sangre,
    String? contextura,
    String? estatura,
    String? cabello,
    String? boca,
    String? ojos,
    String? nariz,
    required String alertNoteUrl,
    String? image1,
  }) async {
    final db = await database;
    return await db.update(
      'reports',
      {
        'name': name,
        'lastName': lastName,
        'status': status,
        'age': age,
        'bornCountry': bornCountry,
        'lastSeen': lastSeen,
        'placeLastSeen': placeLastSeen,
        'tez': tez,
        'sangre': sangre,
        'contextura': contextura,
        'estatura': estatura,
        'cabello': cabello,
        'boca': boca,
        'ojos': ojos,
        'nariz': nariz,
        'alertNoteUrl': alertNoteUrl,
        'image1': image1,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Eliminar un reporte
  Future<int> deleteReport(int id) async {
    final db = await database;
    return await db.delete(
      'reports',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
