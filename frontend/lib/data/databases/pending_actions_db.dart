import 'dart:convert';
import 'package:frontend/data/databases/db_helper.dart';
import 'package:frontend/data/models/pending_actions_model.dart';

class PendingActionsDb {
  static const String table = 'pending_actions';

  static Future<void> add({
    required String actionType,
    required Map<String, dynamic> payload,
  }) async {
    final db = await DBHelper().database;

    await db.insert(
      table,
      PendingActionsModel(actionType: actionType, payload: payload).toJson(),
    );
  }

  static Future<List<PendingActionsModel>> getAll() async {
    final db = await DBHelper().database;
    final data = await db.query(table, orderBy: 'id ASC');

    return data.map((itm) => PendingActionsModel.fromJson(itm)).toList();
  }

  static Future<void> delete(int id) async {
    final db = await DBHelper().database;
    await db.delete(table, where: 'id=?', whereArgs: [id]);
  }
}
