// ignore_for_file: always_specify_types

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

  // Update Status berdasarkan ID
  static Future<bool> updateStatusMessage({
    required String id,
    required String status,
  }) async {
    try {
      final Database db = await DBHelper.instance.database;

      final int updated = await db.update(
        _table,
        {'status': status},
        where: "id = ?",
        whereArgs: <String>[id],
      );

      return updated > 0;
    } catch (e) {
      Logger.error("updateStatusMessage: $e");
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

  // Ambil semua chat berdasarkan email pengirim dan penerima (2 arah)
  static Future<List<MessageModel>> getMessagesByEmails({
    required String email1,
    required String email2,
  }) async {
    try {
      final Database db = await DBHelper.instance.database;

      final List<Map<String, dynamic>> result = await db.query(
        _table,
        where:
            "(email_sender = ? AND email_receiver = ?) OR (email_sender = ? AND email_receiver = ?)",
        whereArgs: <String>[email1, email2, email2, email1],
        orderBy: "time ASC",
      );

      return result.map(MessageModel.fromJson).toList();
    } catch (e) {
      Logger.error("getMessagesByEmails: $e");
      return <MessageModel>[];
    }
  }
}
