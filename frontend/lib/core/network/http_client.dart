import 'dart:convert';
import 'package:frontend/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/core/network/api_response.dart';

class HttpClient {
  final Map<String, String>? defaultHeaders;

  const HttpClient({this.defaultHeaders});

  // GET request
  Future<ApiResponse> get({required String endpoint}) async {
    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: defaultHeaders ?? {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] == true) {
        return ApiResponse.fromJson(body);
      } else {
        AppLogger.error(
          body['message']?.toString() ?? 'Unknown message',
          body['error']?.toString(),
        );

        return ApiResponse(
          success: false,
          message: body['message'] ?? '',
          error: body['error']?.toString() ?? 'Unknown error',
        );
      }
    } catch (e, s) {
      AppLogger.error(e.toString(), e, s);

      return ApiResponse(
        success: false,
        message: 'Failed to connect',
        error: e.toString(),
      );
    }
  }

  // POST request
  Future<ApiResponse> post({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: defaultHeaders ?? {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] == true) {
        return ApiResponse.fromJson(body);
      } else {
        return ApiResponse(
          success: false,
          message: body['message'] ?? '',
          error: body['error']?.toString() ?? 'Unknown error',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to connect',
        error: e.toString(),
      );
    }
  }
}
