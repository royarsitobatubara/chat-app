import 'package:frontend/core/utils/app_logger.dart';
import 'package:frontend/data/databases/db_helper.dart';
import 'package:frontend/data/models/contact_model.dart';

class ContactDbService {
  static const String table = 'contacts';

  static Future<bool> addContact({required ContactModel data}) async {
    try {
      final db = await DBHelper().database;

      final exists = await getContactByEmailTo(email: data.emailTo);
      if (exists == true) {
        AppLogger.warn('Contacts is already exists');
        return false;
      }

      final result = await db.insert(table, data.toJson());
      return result > 0;
    } catch (e) {
      AppLogger.error('Error in ContactDbService -> addContact: $e');
      rethrow;
    }
  }

  static Future<bool> getContactByEmail({required String email}) async {
    try {
      final db = await DBHelper().database;
      final data = await db.query(
        table,
        where: 'email_from=?',
        whereArgs: [email],
      );
      return data.isNotEmpty;
    } catch (e) {
      AppLogger.error('Error in ContactDbService -> getContactByEmail: $e');
      rethrow;
    }
  }

  static Future<bool> getContactByEmailTo({required String email}) async {
    try {
      final db = await DBHelper().database;
      final data = await db.query(
        table,
        where: 'email_to=?',
        whereArgs: [email],
      );
      return data.isNotEmpty;
    } catch (e) {
      AppLogger.error('Error in ContactDbService -> getContactByEmailTo: $e');
      rethrow;
    }
  }

  static Future<bool> getContactById({required String id}) async {
    try {
      final db = await DBHelper().database;
      final data = await db.query(table, where: 'id=?', whereArgs: [id]);
      return data.isNotEmpty;
    } catch (e) {
      AppLogger.error('Error in ContactDbService -> getContactById: $e');
      rethrow;
    }
  }

  static Future<List<ContactModel>> getAllContact({
    required String email,
  }) async {
    try {
      final db = await DBHelper().database;

      final data = await db.query(
        table,
        where: 'email_from=?',
        whereArgs: [email],
      );

      return data.isNotEmpty
          ? data.map((e) => ContactModel.fromJson(e)).toList()
          : [];
    } catch (e) {
      AppLogger.error('Error in ContactDbService -> getAllContact: $e');
      rethrow;
    }
  }

  static Future<bool> deleteContactById({required String id}) async {
    try {
      final db = await DBHelper().database;
      final count = await db.delete(table, where: 'id=?', whereArgs: [id]);
      return count > 0;
    } catch (e) {
      AppLogger.error('Error in ContactDbService -> deleteContactById: $e');
      rethrow;
    }
  }
}
