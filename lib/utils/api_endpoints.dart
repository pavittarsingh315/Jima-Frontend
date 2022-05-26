class ApiEndpoints {
  static const String _baseUrl = "https://testing-jima.herokuapp.com/api";
  static const String _authUrl = "$_baseUrl/auth";
  static const String _userUrl = "$_baseUrl/user";

  static const String login = "$_authUrl/login";
  static const String tokenLogin = "$_authUrl/login/token";
  static const String initRegistration = "$_authUrl/register/initial";
  static const String confRegistration = "$_authUrl/register/final";
  static const String reqPasswordReset = "$_authUrl/password/reset/request";
  static const String confPasswordResetCode = "$_authUrl/password/reset/code/confirm";
  static const String confPasswordReset = "$_authUrl/password/reset/confirm";

  static const String editUsername = "$_userUrl/edit/username";
  static const String editName = "$_userUrl/edit/name";
  static const String editBio = "$_userUrl/edit/bio";
  static const String editBlacklistMessage = "$_userUrl/edit/blacklistmessage";
}