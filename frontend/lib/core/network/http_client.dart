import 'dart:convert';
import 'package:frontend/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/core/network/api_response.dart';

class HttpClient {
  final Map<String, String>? defaultHeaders;

  const HttpClient({this.defaultHeaders});

  Map<String, String> get _headers =>
      defaultHeaders ?? {'Content-Type': 'application/json'};

  Map<String, dynamic> _safeDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return {};
    }
  }

  Future<ApiResponse> get({required String endpoint}) async {
    try {
      final response = await http.get(Uri.parse(endpoint), headers: _headers);
      final body = _safeDecode(response.body);

      if (body['success'] == true) {
        return ApiResponse.fromJson(body);
      }

      return ApiResponse(
        success: false,
        message: body['message']?.toString() ?? 'Request failed',
        error: body['error']?.toString(),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to connect',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse> delete({
    required String endpoint,
    required String id,
  }) async {
    try {
      final url = '$endpoint$id';
      final response = await http.delete(Uri.parse(url), headers: _headers);
      final body = _safeDecode(response.body);

      if (body['success'] == true) {
        return ApiResponse.fromJson(body);
      }

      return ApiResponse(
        success: false,
        message: body['message']?.toString() ?? 'Request failed',
        error: body['error']?.toString(),
      );
    } catch (e) {
      AppLogger.error('[DELETE] error: $e');
      return ApiResponse(
        success: false,
        message: 'Failed to connect',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse> post({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: _headers,
        body: jsonEncode(data),
      );

      final body = _safeDecode(response.body);

      if (body['success'] == true) {
        return ApiResponse.fromJson(body);
      }

      return ApiResponse(
        success: false,
        message: body['message']?.toString() ?? 'Request failed',
        error: body['error']?.toString(),
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to connect',
        error: e.toString(),
      );
    }
  }
}
