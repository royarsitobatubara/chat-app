import 'package:flutter/widgets.dart';
import 'package:frontend/data/databases/db_helper.dart';
import 'package:frontend/data/models/user_model.dart';

class UserDbService {
  static const String table = 'users';

  static Future<int> addUser({required UserModel data}) async {
    try {
      final db = await DBHelper().database;
      return await db.insert(table, data.toJson());
    } catch (e) {
      debugPrint('Error in UserDbService -> addUser: $e');
      rethrow;
    }
  }

  static Future<UserModel?> getUserByEmail({required String email}) async {
    try {
      final db = await DBHelper().database;
      final data = await db.query(table, where: 'email=?', whereArgs: [email]);
      if (data.isNotEmpty) {
        return UserModel.fromJson(data.first);
      }
      return null;
    } catch (e) {
      debugPrint('Error in UserDbService -> getUserByEmail: $e');
      rethrow;
    }
  }
}
