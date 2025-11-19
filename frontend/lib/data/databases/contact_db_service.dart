import 'package:flutter/material.dart';
import 'package:frontend/data/databases/db_helper.dart';
import 'package:frontend/data/models/contact_model.dart';

class ContactDbService {
  static const String table = 'contacts';

  static Future<int> addContact({required ContactModel data}) async {
    try {
      final db = await DBHelper().database;
      return await db.insert(table, data.toJson());
    } catch (e) {
      debugPrint('Error in ContactDbService -> addContact: $e');
      rethrow;
    }
  }

  static Future<int> getContactByEmail({required String email}) async {
    try {
      final db = await DBHelper().database;
      final data = await db.query(table, where: 'email=?', whereArgs: [email]);
      if (data.isNotEmpty) {
        return 1;
      }
      return 0;
    } catch (e) {
      rethrow;
    }
  }
}
