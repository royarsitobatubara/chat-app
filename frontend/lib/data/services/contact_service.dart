import 'package:frontend/core/constants/api_url.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/core/network/http_client.dart';
import 'package:frontend/data/databases/contact_db_service.dart';
import 'package:frontend/data/databases/pending_actions_db.dart';
import 'package:frontend/data/databases/user_db_service.dart';
import 'package:frontend/data/models/contact_model.dart';
import 'package:frontend/data/models/user_model.dart';

class ContactService {
  final client = HttpClient();

  Future<ApiResponse> addContact({
    required String emailFrom,
    required String emailTo,
  }) async {
    try {
      // COBA KIRIM KE SERVER
      final res = await client.post(
        endpoint: ApiUrl.addContact,
        data: {'email_from': emailFrom, 'email_to': emailTo},
      );

      // JIKA BERHASIL MENGIRIM DATA KE SERVER
      if (res.success == true) {
        // SIMPAN DATA KE LOKAL
        final contactData = res.data['contact'];
        final userData = res.data['user'];

        await ContactDbService.addContact(
          data: ContactModel(
            id: contactData['id'],
            emailFrom: contactData['email_from'],
            emailTo: contactData['email_to'],
          ),
        );

        await UserDbService.addUser(
          data: UserModel(
            id: userData['id'],
            email: userData['email'],
            username: userData['username'],
            photo: userData['photo'],
          ),
        );
      }

      return res;
    } catch (e) {
      await PendingActionsDb.add(
        actionType: 'add_contact',
        payload: {'email_from': emailFrom, 'email_to': emailTo},
      );

      return ApiResponse(
        success: false,
        message: 'Add contact failed',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse> deleteContactById({required String id}) async {
    try {
      // HAPUS DI LOCAL DULU
      await ContactDbService.deleteContactById(id: id);
      await UserDbService.deleteUserById(id: id);

      // COBA HAPUS DARI SERVER
      final res = await client.delete(
        endpoint: ApiUrl.getContactByEmail,
        id: id,
      );

      // JIKA BERHASIL MAKA LANGSUNG KIRIM RESPON
      if (res.success == true) {
        return res;
      }

      // JIKA GAGAL MAKA MASUKAN KE PENDING
      await PendingActionsDb.add(
        actionType: 'delete_contact',
        payload: {'id': id},
      );

      return res;
    } catch (e) {
      await PendingActionsDb.add(
        actionType: 'delete_contact',
        payload: {'id': id},
      );
      return ApiResponse(
        success: false,
        message: 'Delete contact failed',
        error: e.toString(),
      );
    }
  }
}
