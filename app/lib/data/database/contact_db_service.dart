import 'package:app/data/database/db_helper.dart';
import 'package:app/data/models/contact_model.dart';
import 'package:sqflite/sqflite.dart';

class ContactDbService {
  static const String _table = "contacts";

  static Future<bool> addUser(ContactModel contact) async {
    try {
      final Database db = await DBHelper.instance.database;

      // Cek apakah email sudah ada
      final List<Map<String, dynamic>> exist = await db.query(
        _table,
        where: 'email_receiver = ?',
        whereArgs: <String>[contact.emailReceiver],
        limit: 1,
      );

      if (exist.isNotEmpty) {
        // Update data user
        await db.update(
          _table,
          contact.toJson(),
          where: "email_receiver = ?",
          whereArgs: <String>[contact.emailReceiver],
        );
        return true;
      }

      // Insert user baru
      await db.insert(_table, contact.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
