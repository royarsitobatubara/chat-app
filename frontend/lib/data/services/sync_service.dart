import 'package:frontend/data/databases/pending_actions_db.dart';
import 'package:frontend/data/services/contact_service.dart';
import 'package:frontend/data/services/user_service.dart';

class SyncService {
  static final _contactService = ContactService();
  static final _userService = UserService();

  static Future<void> syncPending() async {
    final pending = await PendingActionsDb.getAll();

    for (final item in pending) {
      final type = item.actionType;
      final payload = item.payload;

      bool success = false;

      try {
        // DELETE CONTACT
        if (type == 'delete_contact') {
          final res = await _contactService.deleteContactById(
            id: payload['id'],
          );
          if (res.success == true || res.message == 'Contact does not exist') {
            success = true;
          }
        }
        // ADD CONTACT
        else if (type == 'add_contact') {
          final res = await _contactService.addContact(
            emailFrom: payload['email_from'],
            emailTo: payload['email_to'],
          );
          if (res.success == true || res.message == 'Contact already exists') {
            success = true;
          }
        } else if (type == 'update_username') {
          final res = await _userService.updateUsername(
            email: payload['username'],
            username: payload['username'],
          );
          if (res.success == true) {
            success = true;
          }
        }
      } catch (_) {
        // Error jaringan → jangan hapus pending
        success = false;
      }

      if (success) {
        await PendingActionsDb.delete(item.id!);
      }
    }
  }
}
