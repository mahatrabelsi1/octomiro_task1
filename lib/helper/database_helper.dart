import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initializeDB();
    return _db!;
  }

  Future<Database> _initializeDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> createUser(String username, String email, String password) async {
    final db = await database;
    return db.insert('users', {
      'username': username,
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
