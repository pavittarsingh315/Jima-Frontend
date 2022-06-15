class ApiEndpoints {
  static const String _baseUrl = "https://testing-jima.herokuapp.com/api";
  static const String _authUrl = "$_baseUrl/auth";
  static const String _userUrl = "$_baseUrl/user";
  static const String _utilUrl = "$_baseUrl/util";

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
  static const String editProfilePicture = "$_userUrl/edit/profilePicture";

  static const String getProfilePicUploadUrl = "$_utilUrl/getPresignUrl/profilePicture";

  /// Append query to the end of the url.
  static const String searchForUser = "$_userUrl/profile/search/user";
  static const String getSearchHistory = "$_userUrl/profile/search/history/get";
  static const String clearSearchHistory = "$_userUrl/profile/search/history/clear";

  /// Append query to end of the url
  static const String addToSearchHistory = "$_userUrl/profile/search/history/add";

  /// Append index of search to remove to the end of the url
  static const String removeFromSearchHistory = "$_userUrl/profile/search/history/remove";
}
