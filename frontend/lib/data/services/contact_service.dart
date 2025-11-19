import 'package:frontend/core/constants/api_url.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/core/network/http_client.dart';
import 'package:frontend/data/databases/contact_db_service.dart';
import 'package:frontend/data/models/contact_model.dart';

class ContactService {
  final client = HttpClient();

  Future<ApiResponse> addContact({
    required String emailFrom,
    required String emailTo,
  }) async {
    final data = {'email_from': emailFrom, 'email_to': emailTo};
    final checkUser = await ContactDbService.getContactByEmail(email: emailTo);
    if(checkUser > 0){
      return ApiResponse(
        success: false,
        message: 'Contact is already exists',
        error: null
      );
    }
    final result = await client.post(endpoint: ApiUrl.addContact, data: data);
    final dataResult = await result.data;
    await ContactDbService.addContact(
      data: ContactModel(
        id: dataResult['id'] as String,
        emailFrom: dataResult['email_from'] as String,
        emailTo: dataResult['email_to'] as String,
      ),
    );
    return result;
  }

  Future<ApiResponse> getContactByEmail({required String email}) async {
    final endPoint = '${ApiUrl.getContactByEmail}/$email';
    return await client.get(endpoint: endPoint);
  }
}
