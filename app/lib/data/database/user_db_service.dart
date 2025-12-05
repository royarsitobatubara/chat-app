import 'package:app/data/database/db_helper.dart';
import 'package:app/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class UserDbService {
  static const String _table = "users";

  static Future<bool> addUser(UserModel user) async {
    try {
      final Database db = await DBHelper.instance.database;

      // Cek apakah email sudah ada
      final List<Map<String, dynamic>> exist = await db.query(
        _table,
        where: 'email = ?',
        whereArgs: <String>[user.email],
        limit: 1,
      );

      if (exist.isNotEmpty) {
        // Update data user
        await db.update(
          _table,
          user.toJson(),
          where: "email = ?",
          whereArgs: <String>[user.email],
        );
        return true;
      }

      // Insert user baru
      await db.insert(_table, user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<UserModel?> getUserByEmailReceiver(String emailReceiver) async {
    try {
      final Database db = await DBHelper.instance.database;

      final List<Map<String, dynamic>> result = await db.query(
        _table,
        where: 'email = ?',
        whereArgs: <String>[emailReceiver],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return UserModel.fromJson(result.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
