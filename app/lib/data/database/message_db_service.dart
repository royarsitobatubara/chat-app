import 'package:app/core/helper/logger.dart';
import 'package:app/data/database/db_helper.dart';
import 'package:app/data/models/message_model.dart';
import 'package:sqflite/sqflite.dart';

class MessageDbService {
  static const String _table = "messages";

  // Tambah chat
  static Future<bool> addMessage(MessageModel msg) async {
    try {
      final Database db = await DBHelper.instance.database;

      await db.insert(_table, msg.toJson());
      return true;
    } catch (e) {
      Logger.error("addMessage: $e");
      return false;
    }
  }

  // Update chat berdasarkan ID
  static Future<bool> updateMessage(String id, MessageModel msg) async {
    try {
      final Database db = await DBHelper.instance.database;

      final int updated = await db.update(
        _table,
        msg.toJson(),
        where: "id = ?",
        whereArgs: <String>[id],
      );

      return updated > 0;
    } catch (e) {
      Logger.error("updateMessage: $e");
      return false;
    }
  }

  // Hapus chat berdasarkan ID
  static Future<bool> deleteMessage(String id) async {
    try {
      final Database db = await DBHelper.instance.database;

      final int deleted = await db.delete(
        _table,
        where: "id = ?",
        whereArgs: <String>[id],
      );

      return deleted > 0;
    } catch (e) {
      Logger.error("deleteMessage: $e");
      return false;
    }
  }

  static Future<bool> updateFields(String id, Map<String, dynamic> data) async {
    try {
      final Database db = await DBHelper.instance.database;

      final int updated = await db.update(
        _table,
        data,
        where: "id = ?",
        whereArgs: <String>[id],
      );

      return updated > 0;
    } catch (e) {
      Logger.error("updateFields: $e");
      return false;
    }
  }
}
