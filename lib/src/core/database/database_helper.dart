import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'agriwise.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    // Create user table
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT UNIQUE,
        phone TEXT,
        created_at TEXT
      )
    ''');

    // Create crop table
    await db.execute('''
      CREATE TABLE crops(
        id TEXT PRIMARY KEY,
        user_id TEXT,
        name TEXT,
        variety TEXT,
        planting_date TEXT,
        expected_harvest_date TEXT,
        status TEXT,
        created_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Create advisory table
    await db.execute('''
      CREATE TABLE advisories(
        id TEXT PRIMARY KEY,
        crop_id TEXT,
        title TEXT,
        description TEXT,
        created_at TEXT,
        FOREIGN KEY (crop_id) REFERENCES crops (id)
      )
    ''');
  }

  // User operations
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return maps.first;
  }

  // Crop operations
  Future<void> insertCrop(Map<String, dynamic> crop) async {
    final db = await database;
    await db.insert(
      'crops',
      crop,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUserCrops(String userId) async {
    final db = await database;
    return await db.query(
      'crops',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // Advisory operations
  Future<void> insertAdvisory(Map<String, dynamic> advisory) async {
    final db = await database;
    await db.insert(
      'advisories',
      advisory,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCropAdvisories(String cropId) async {
    final db = await database;
    return await db.query(
      'advisories',
      where: 'crop_id = ?',
      whereArgs: [cropId],
    );
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
} 