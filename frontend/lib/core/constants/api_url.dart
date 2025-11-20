class ApiUrl {
  static const String _baseUrl = "http://192.168.100.152:3000/api";

  // PING SERVER
  static const String ping = '$_baseUrl/ping';

  // USER
  static const String signIn = '$_baseUrl/user/signin';
  static const String signUp = '$_baseUrl/user/signup';
  static const String getUserByKeyword = '$_baseUrl/user/search?user=';
  static const String deleteUserById = '$_baseUrl/user/';

  // CONTACT
  static const String addContact = '$_baseUrl/contact/add';
  static const String getContactByEmail = '$_baseUrl/contact';
  static const String deleteContactById = '$_baseUrl/contact/';
}
