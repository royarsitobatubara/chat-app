import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;
  static const String _dbName = 'chatapp.db';
  static const int _version = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(path, version: _version, onCreate: _onCreate);
  }

  static Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await deleteDatabase(path);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        username TEXT NOT NULL,
        photo TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE contacts (
        id TEXT PRIMARY KEY,
        email_from TEXT NOT NULL,
        email_to TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        message TEXT NOT NULL,
        sender TEXT NOT NULL,
        receiver TEXT NOT NULL,
        type TEXT NOT NULL,
        isRead INTEGER,
        time TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE pending_actions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action_type TEXT NOT NULL,     
        payload TEXT NOT NULL,      
      );
    ''');
  }
}
