import 'package:app/core/helper/logger.dart';
import 'package:app/data/database/db_helper.dart';
import 'package:app/data/models/contact_model.dart';
import 'package:sqflite/sqflite.dart';

class ContactDbService {
  static const String _table = "contacts";

  static Future<bool> addContact(ContactModel contact) async {
    try {
      final Database db = await DBHelper.instance.database;

      // Cek apakah email sudah ada
      final List<Map<String, dynamic>> exist = await db.query(
        _table,
        where: 'email_sender=? AND email_receiver = ?',
        whereArgs: <String>[contact.emailSender, contact.emailReceiver],
        limit: 1,
      );

      if (exist.isNotEmpty) {
        // Update data user
        await db.update(
          _table,
          contact.toJson(),
          where: "email_sender=? AND email_receiver=?",
          whereArgs: <String>[contact.emailSender, contact.emailReceiver],
        );
        return true;
      }

      // Insert user baru
      await db.insert(_table, contact.toJson());
      return true;
    } catch (e) {
      Logger.error('addContact: $e');
      return false;
    }
  }

  static Future<List<ContactModel>> getAllContacts(String emailSender) async {
    try {
      final Database db = await DBHelper.instance.database;

      final List<Map<String, dynamic>> result = await db.query(
        _table,
        where: 'email_sender = ?',
        whereArgs: <String>[emailSender],
        orderBy: 'id DESC',
      );

      return result.map((Map<String, dynamic> item) {
        return ContactModel.fromJson(item);
      }).toList();
    } catch (e) {
      Logger.error('getAllContacts: $e');
      return <ContactModel>[];
    }
  }

  static Future<ContactModel?> getContactByEmails(
    String emailSender,
    String emailReceiver,
  ) async {
    try {
      final Database db = await DBHelper.instance.database;

      final List<Map<String, dynamic>> result = await db.query(
        _table,
        where: 'email_sender = ? AND email_receiver = ?',
        whereArgs: <String>[emailSender, emailReceiver],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return ContactModel.fromJson(result.first);
      }
      return null;
    } catch (e) {
      Logger.error('getContactByEmails: $e');
      return null;
    }
  }
}
