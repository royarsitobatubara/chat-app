class AppEndpoint {
  static const String baseUrl = "http://192.168.100.152:3000";

  // USER ENDPOINT
  static const String signIn = "$baseUrl/api/user/signin";
  static const String signUp = "$baseUrl/api/user/signup";
  static const String searchUser = "$baseUrl/api/user/search?user=";
}
