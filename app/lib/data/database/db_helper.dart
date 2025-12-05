import 'package:app/core/helper/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'myapp.db');
    Logger.info("Opening database");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> deleteDatabaseFile() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'myapp.db');

    await deleteDatabase(path);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        username TEXT,
        EMAIL TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email_sender TEXT,
        email_receiver TEXT
      )
    ''');
  }
}
