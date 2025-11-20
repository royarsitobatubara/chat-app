import 'package:frontend/data/databases/pending_actions_db.dart';
import 'package:frontend/data/services/user_service.dart';

class SyncService {
  static Future<void> syncPending() async {
    final pending = await PendingActionsDb.getAll();

    for (final item in pending) {
      try {
        final type = item.actionType;
        final payload = item.payload;

        if (type == 'delete_user') {
          await UserService().deleteUserById(id: payload['id']);
        }

        // kalau action lain, tambahkan di sini
        // if (type == 'add_contact') ....

        // kalau berhasil
        await PendingActionsDb.delete(item.id!);
      } catch (_) {
        // kalau gagal, ya udah lanjut item berikutnya
        continue;
      }
    }
  }
}
