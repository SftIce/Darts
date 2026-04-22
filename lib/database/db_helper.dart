import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DartsDatabase {
  static final DartsDatabase instance = DartsDatabase._init();
  static Database? _database;
  DartsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('darts_vfinal.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: (db, v) async {
      await db.execute('CREATE TABLE stats (name TEXT PRIMARY KEY, wins INTEGER, garys INTEGER)');
    });
  }

  Future<void> logWin(String name) async {
    final db = await database;
    await db.execute('INSERT OR IGNORE INTO stats VALUES (?, 0, 0)', [name]);
    await db.execute('UPDATE stats SET wins = wins + 1 WHERE name = ?', [name]);
  }

  Future<void> logGary(String name) async {
    final db = await database;
    await db.execute('INSERT OR IGNORE INTO stats VALUES (?, 0, 0)', [name]);
    await db.execute('UPDATE stats SET garys = garys + 1 WHERE name = ?', [name]);
  }
}
