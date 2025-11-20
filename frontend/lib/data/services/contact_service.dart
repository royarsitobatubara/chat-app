import 'package:frontend/core/constants/api_url.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/core/network/http_client.dart';
import 'package:frontend/data/databases/contact_db_service.dart';
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
      final exists = await ContactDbService.getContactByEmailTo(email: emailTo);
      if (exists == true) {
        return ApiResponse(
          success: false,
          message: 'Contact already exists',
        );
      }

      final res = await client.post(
        endpoint: ApiUrl.addContact,
        data: {'email_from': emailFrom, 'email_to': emailTo},
      );

      if (res.data == null) return res;

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

      return res;
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Add contact failed',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse> deleteContactById({required String id}) async {
    try {
      final exists = await ContactDbService.getContactById(id: id);
      if (!exists) {
        return ApiResponse(
          success: false,
          message: 'Contact does not exist',
        );
      }

      await ContactDbService.deleteContactById(id: id);
      await UserDbService.deleteUserById(id: id);

      final res = await client.delete(
        endpoint: ApiUrl.getContactByEmail,
        id: id,
      );

      return res;
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Delete contact failed',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse> getContactByEmail({required String email}) async {
    try {
      return await client.get(
        endpoint: '${ApiUrl.getContactByEmail}/$email',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Get contact failed',
        error: e.toString(),
      );
    }
  }
}
