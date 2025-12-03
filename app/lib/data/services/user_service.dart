

import 'package:app/core/constants/app_endpoint.dart';
import 'package:app/core/helper/api_response.dart';
import 'package:app/core/helper/http_client.dart';
import 'package:app/core/helper/logger.dart';

Future<ApiResponse> searchUser(String keyword) async {
  try {
    final ApiResponse res = await HttpClient().get(
      endpoint: '${AppEndpoint.searchUser}$keyword',
    );
    return res;
  } catch (e) {
    Logger.error('searchUser: $e');
    return ApiResponse(success: false, statusCode: 500, message: e.toString());
  }
}

