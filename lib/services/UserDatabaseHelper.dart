import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/User.dart';

class UserDatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            userId TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            profilePic TEXT
          )
        ''');
      },
    );
  }

  // Insert a user
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get a user by ID
  Future<User?> getUser(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users', where: 'userId = ?', whereArgs: [userId]);

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Delete a user
  Future<void> deleteUser(String userId) async {
    final db = await database;
    await db.delete('users', where: 'userId = ?', whereArgs: [userId]);
  }

  // Delete a user
  Future<void> clearUserDb() async {
    final db = await database;
    await db.delete('users');
  }
}
