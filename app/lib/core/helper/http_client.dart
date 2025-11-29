import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/core/helper/api_response.dart';

class HttpClient {
  final Map<String, String> defaultHeaders = <String, String>{
    'Content-Type': 'application/json',
  };

  Future<ApiResponse> get({required String endpoint}) async {
    try {
      final http.Response res = await http.get(
        Uri.parse(endpoint),
        headers: defaultHeaders,
      );

      return _parseResponse(res);
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 500,
        message: 'Request gagal: $e',
        timeStamp: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<ApiResponse> post({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      final http.Response res = await http.post(
        Uri.parse(endpoint),
        headers: defaultHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      return _parseResponse(res);
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 500,
        message: 'Request gagal: $e',
        timeStamp: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<ApiResponse> delete({required String endpoint}) async {
    try {
      final http.Response res = await http.delete(
        Uri.parse(endpoint),
        headers: defaultHeaders,
      );

      return _parseResponse(res);
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 500,
        message: 'Request gagal: $e',
        timeStamp: DateTime.now().toIso8601String(),
      );
    }
  }

  ApiResponse _parseResponse(http.Response res) {
    try {
      final dynamic jsonBody = jsonDecode(res.body);

      return ApiResponse.fromJson(jsonBody);
    } catch (_) {
      return ApiResponse(
        success: false,
        statusCode: res.statusCode,
        message: 'Format response tidak valid',
        timeStamp: DateTime.now().toIso8601String(),
      );
    }
  }
}
