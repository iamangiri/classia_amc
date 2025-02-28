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
        exchange TEXT,
        quantity INTEGER DEFAULT 1 -- Added quantity column
      )
    ''');
  }

  // ✅ Insert a company or update quantity if it exists
  Future<void> insertOrUpdateCompany(Map<String, dynamic> company) async {
    final db = await database;
    final existing = await db.query(
      'selected_companies',
      where: 'id = ?',
      whereArgs: [company['id']],
    );

    if (existing.isNotEmpty) {
      int newQuantity = (existing.first['quantity'] as int) + 1;
      await db.update(
        'selected_companies',
        {'quantity': newQuantity},
        where: 'id = ?',
        whereArgs: [company['id']],
      );
    } else {
      company['quantity'] = 1;
      await db.insert(
        'selected_companies',
        company,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // ✅ Remove company or decrease quantity
  Future<void> deleteCompany(String id) async {
    final db = await database;
    final existing = await db.query(
      'selected_companies',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (existing.isNotEmpty) {
      int currentQuantity = existing.first['quantity'] as int;

      if (currentQuantity > 1) {
        await db.update(
          'selected_companies',
          {'quantity': currentQuantity - 1},
          where: 'id = ?',
          whereArgs: [id],
        );
      } else {
        await db.delete(
          'selected_companies',
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    }
  }

  // ✅ Get list of selected companies
  Future<List<Map<String, dynamic>>> getSelectedCompanies() async {
    final db = await database;
    return await db.query('selected_companies');
  }

  // ✅ Update quantity directly
  Future<void> updateCompanyQuantity(String id, int change) async {
    final db = await database;
    final existing = await db.query(
      'selected_companies',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (existing.isNotEmpty) {
      int currentQuantity = existing.first['quantity'] as int;
      int newQuantity = currentQuantity + change;

      if (newQuantity > 0) {
        await db.update(
          'selected_companies',
          {'quantity': newQuantity},
          where: 'id = ?',
          whereArgs: [id],
        );
      } else {
        await deleteCompany(id); // Remove if quantity reaches 0
      }
    }
  }
}
