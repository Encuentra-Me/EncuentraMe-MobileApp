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
        url TEXT
      )
    ''');
  }

  // Agregar un report
  Future<int> addReport(
      String name,
      String lastName,
      String status,
      String age,
      String bornCountry,
      String lastSeen,
      String placeLastSeen,
      String url) async {
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
        'url': url
      },
    );
  }

  // Obtener todos los reportes
  Future<List<Map<String, dynamic>>> getReports() async {
    final db = await database;
    return await db.query('reports');
  }

// Actualizar un reporte
  Future<int> updateReport(
      int id,
      String name,
      String lastName,
      String status,
      String age,
      String bornCountry,
      String lastSeen,
      String placeLastSeen,
      String url) async {
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
        'url': url
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
