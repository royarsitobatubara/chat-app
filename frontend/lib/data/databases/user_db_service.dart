import 'package:frontend/core/utils/app_logger.dart';
import 'package:frontend/data/databases/db_helper.dart';
import 'package:frontend/data/models/user_model.dart';

class UserDbService {
  static const String table = 'users';

  static Future<int> addUser({required UserModel data}) async {
    try {
      final db = await DBHelper().database;
      return await db.insert(table, data.toJson());
    } catch (e) {
      AppLogger.error('Error in UserDbService -> addUser: $e');
      rethrow;
    }
  }

  static Future<UserModel?> getUserByEmail({required String email}) async {
    try {
      final db = await DBHelper().database;
      final data = await db.query(table, where: 'email=?', whereArgs: [email]);

      return data.isNotEmpty ? UserModel.fromJson(data.first) : null;
    } catch (e) {
      AppLogger.error('Error in UserDbService -> getUserByEmail: $e');
      rethrow;
    }
  }

  static Future<bool> deleteUserById({required String id}) async {
    try {
      final db = await DBHelper().database;
      return await db.delete(table, where: 'id=?', whereArgs: [id]) > 0;
    } catch (e) {
      AppLogger.error('Error in UserDbService -> deleteUserById: $e');
      rethrow;
    }
  }

  static Future<List<UserModel>> getUserByKeyword({
    required String keyword,
  }) async {
    try {
      final db = await DBHelper().database;

      final data = await db.query(
        table,
        where: 'username LIKE ? OR email LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%'],
      );

      return data.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      AppLogger.error('Error in UserDbService -> getUserByKeyword: $e');
      rethrow;
    }
  }
}
