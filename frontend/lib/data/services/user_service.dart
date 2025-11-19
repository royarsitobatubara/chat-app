import 'package:frontend/core/constants/api_url.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/core/network/http_client.dart';

class UserService {
  final client = HttpClient();

  Future<ApiResponse> signIn({
    required String email,
    required String password,
  }) async {
    final data = {'email': email, 'password': password};
    return await client.post(endpoint: ApiUrl.signIn, data: data);
  }

  Future<ApiResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final data = {'email': email, 'password': password, 'username': username};
    return await client.post(endpoint: ApiUrl.signUp, data: data);
  }

  Future<ApiResponse> pingServer() async {
    return await client.get(endpoint: ApiUrl.ping);
  }

  Future<ApiResponse> getUserByKeyword({required String keyword}) async {
    final data = '${ApiUrl.getUserByKeyword}$keyword';
    return await client.get(endpoint: data);
  }
}
