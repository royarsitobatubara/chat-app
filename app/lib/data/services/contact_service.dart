import 'package:app/core/constants/app_endpoint.dart';
import 'package:app/core/helper/api_response.dart';
import 'package:app/core/helper/http_client.dart';
import 'package:app/core/helper/logger.dart';

Future<ApiResponse> insertContact({required String emailSender, required String emailReceiver}) async {
  try {
    final ApiResponse res = await HttpClient().post(
      endpoint: AppEndpoint.insert,
      body: <String, String>{
        'email_sender': emailSender,
        'email_receiver': emailReceiver
      },
    );
    return res;
  } catch (e) {
    Logger.error('insertContact: $e');
    return ApiResponse(success: false, statusCode: 500, message: e.toString());
  }
}
