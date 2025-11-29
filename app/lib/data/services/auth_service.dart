import 'package:app/core/constants/app_endpoint.dart';
import 'package:app/core/helper/api_response.dart';
import 'package:app/core/helper/http_client.dart';
import 'package:app/core/helper/logger.dart';

Future<ApiResponse> signIn({
  required String email,
  required String password,
}) async {
  try {
    final ApiResponse res = await HttpClient().post(
      endpoint: AppEndpoint.signIn,
      body: <String, String>{'email': email, 'password': password},
    );
    return res;
  } catch (e) {
    Logger.error('SIGNIN: $e');
    return ApiResponse(success: false, statusCode: 500, message: e.toString());
  }
}

Future<ApiResponse> signUp({
  required String username,
  required String email,
  required String password,
}) async {
  try {
    final ApiResponse res = await HttpClient().post(
      endpoint: AppEndpoint.signUp,
      body: <String, String>{
        'username': username,
        'email': email,
        'password': password,
      },
    );
    return res;
  } catch (e) {
    Logger.error('SIGNUP: $e');
    return ApiResponse(success: false, statusCode: 500, message: e.toString());
  }
}
