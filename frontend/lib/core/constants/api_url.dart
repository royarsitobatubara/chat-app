class ApiUrl {
  static const String _baseUrl = "http://192.168.0.107:3000/api";

  // PING SERVER
  static const String ping = '$_baseUrl/ping';

  // USER
  static const String signIn = '$_baseUrl/user/signin';
  static const String signUp = '$_baseUrl/user/signup';
  static const String updateUsername = '$_baseUrl/user/update/username';
  static const String updatePassword = '$_baseUrl/user/update/password';
  static const String getUserByKeyword = '$_baseUrl/user/search?user=';

  // CONTACT
  static const String addContact = '$_baseUrl/contact/add';
  static const String getContactByEmail = '$_baseUrl/contact';
  static const String deleteContactById = '$_baseUrl/contact';
}
