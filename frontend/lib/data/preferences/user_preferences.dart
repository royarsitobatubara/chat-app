import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  // LOGIN
  static Future<void> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', value);
  }

  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  // EMAIL
  static Future<void> setEmail(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', value);
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }
}
