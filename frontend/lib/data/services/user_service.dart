import 'package:frontend/core/constants/api_url.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/core/network/http_client.dart';
import 'package:frontend/core/utils/app_logger.dart';
import 'package:frontend/data/databases/pending_actions_db.dart';
import 'package:frontend/data/databases/user_db_service.dart';

class UserService {
  final client = HttpClient();

  Future<ApiResponse> signIn({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return ApiResponse(success: false, message: 'All fields cannot be empty');
    }
    try {
      return await client.post(
        endpoint: ApiUrl.signIn,
        data: {'email': email, 'password': password},
      );
    } catch (e) {
      AppLogger.error('Error : $e');
      return ApiResponse(
        success: false,
        message: 'Sign in failed',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      return ApiResponse(success: false, message: 'All fields cannot be empty');
    }
    try {
      return await client.post(
        endpoint: ApiUrl.signUp,
        data: {'email': email, 'password': password, 'username': username},
      );
    } catch (e) {
      AppLogger.error('Error : $e');
      return ApiResponse(
        success: false,
        message: 'Sign up failed',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse> pingServer() async {
    try {
      return await client.get(endpoint: ApiUrl.ping);
    } catch (e) {
      AppLogger.error('Error : $e');
      return ApiResponse(
        success: false,
        message: 'Ping failed',
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse> getUserByKeyword({required String keyword}) async {
    try {
      final online = await client.get(
        endpoint: '${ApiUrl.getUserByKeyword}$keyword',
      );

      if (online.success == true) return online;

      final local = await UserDbService.getUserByKeyword(keyword: keyword);

      return ApiResponse(
        success: true,
        message: 'Loaded from local DB',
        data: local.map((e) => e.toJson()).toList(),
      );
    } catch (e) {
      final local = await UserDbService.getUserByKeyword(keyword: keyword);
      AppLogger.error('Error : $e');
      return ApiResponse(
        success: true,
        message: 'Loaded from local DB (offline mode)',
        data: local.map((e) => e.toJson()).toList(),
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse> updateUsername({
    required String email,
    required String username,
  }) async {
    if (email.trim().isEmpty || username.trim().isEmpty) {
      return ApiResponse(success: false, message: 'All fields cannot be empty');
    }

    try {
      // kirim ke server
      final data = await client.update(
        endpoint: ApiUrl.updateUsername, // <-- jangan signUp
        data: {'email': email, 'username': username},
      );

      // sukses dari server
      if (data.success == true) {
        await UserDbService.updateUsername(email: email, username: username);

        return ApiResponse(
          success: true,
          message: data.message,
          data: data.data,
        );
      }

      // gagal tapi bukan internal error: masukkan ke pending
      if (data.message != 'internal server error') {
        await PendingActionsDb.add(
          actionType: 'update_username',
          payload: {'email': email, 'username': username},
        );
      }

      return ApiResponse(
        success: data.success,
        message: data.message,
        error: data.error ?? "Unknown error",
      );
    } catch (e) {
      AppLogger.error('Error : $e');

      await PendingActionsDb.add(
        actionType: 'update_username',
        payload: {'email': email, 'username': username},
      );

      return ApiResponse(
        success: false,
        message: 'Update username failed', // <-- jangan sign up
        error: e.toString(),
      );
    }
  }
}
