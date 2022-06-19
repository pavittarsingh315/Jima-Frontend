class ApiEndpoints {
  static const String _baseUrl = "https://testing-jima.herokuapp.com/api";
  static const String _authUrl = "$_baseUrl/auth";
  static const String _userUrl = "$_baseUrl/user";
  static const String _profileUrl = "$_userUrl/profile";
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

  static const String searchForUser = "$_profileUrl/search/user"; // Append query to the end of the url.
  static const String getSearchHistory = "$_profileUrl/search/history/get";
  static const String clearSearchHistory = "$_profileUrl/search/history/clear";
  static const String addToSearchHistory = "$_profileUrl/search/history/add"; // Append query to end of the url
  static const String removeFromSearchHistory = "$_profileUrl/search/history/remove"; // Append index of search to remove to the end of the url

  static const String getAProfile = "$_profileUrl/get"; // Append profileId of profile to get to the end of the url

  static const String addToWhitelist = "$_profileUrl/whitelist/add"; // Append the profileId of profile to whitelist to the end of the url
  static const String removeFromWhitelist = "$_profileUrl/whitelist/remove"; // Append the profileId of profile to blacklist to the end of the url
  static const String getWhitelist = "$_profileUrl/whitelist/get";

  static const String followAUser = "$_profileUrl/follow"; // Append the profileId of profile to follow to the end of the url
  static const String unfollowAUser = "$_profileUrl/unfollow"; // Append the profileId of profile to unfollow to the end of the url
  static const String removeAFollower = "$_profileUrl/followers/remove"; // Append the profileId of profile to remove to the end of the url
  static const String getAProfilesFollowers = "$_profileUrl/followers"; // Append the profileId of profile to get followers for to the end of the url
  static const String getAProfilesFollowing = "$_profileUrl/following"; // Append the profileId of profile to get followings for to the end of the url
}
