import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'market.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE selected_companies(
        id TEXT PRIMARY KEY,
        name TEXT,
        symbol TEXT,
        exchange TEXT
      )
    ''');
  }

  Future<void> insertCompany(Map<String, dynamic> company) async {
    final db = await database;
    await db.insert('selected_companies', company, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteCompany(String id) async {
    final db = await database;
    await db.delete('selected_companies', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getSelectedCompanies() async {
    final db = await database;
    return await db.query('selected_companies');
  }
}