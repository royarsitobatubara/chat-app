import 'package:shared_preferences/shared_preferences.dart';

class DataPreferences {
  // LOGIN
  static Future<void> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', value);
  }

  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  // TOKEN
  static Future<void> setToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', value);
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}