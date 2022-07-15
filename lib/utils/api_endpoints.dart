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

  static const String searchForUser = "$_profileUrl/search/user"; // append "/query". endpoint also takes ?page= and ?limit= url params
  static const String getSearchHistory = "$_profileUrl/search/history/get";
  static const String clearSearchHistory = "$_profileUrl/search/history/clear";
  static const String addToSearchHistory = "$_profileUrl/search/history/add"; // append "/toBeAddedSearch"
  static const String removeFromSearchHistory = "$_profileUrl/search/history/remove"; // append "/toBeDeletedIndex"

  static const String getAProfile = "$_profileUrl/get"; // append "/profileOwnerProfileId"

  static const String inviteToWhitelist = "$_profileUrl/whitelist/invite"; // append "/toBeInvitedProfileId"
  static const String revokeWhitelistInvite = "$_profileUrl/whitelist/invite/revoke"; // append "/toBeDeletedInviteId"
  static const String acceptWhitelistInvite = "$_profileUrl/whitelist/invite/accept"; // append "/toBeAcceptedInviteId"
  static const String declineWhitelistInvite = "$_profileUrl/whitelist/invite/decline"; // append "/toBeDeclinedInviteId"
  static const String requestWhitelistEntry = "$_profileUrl/whitelist/request"; // append "/toRequestProfileId"
  static const String cancelWhitelistEntryRequest = "$_profileUrl/whitelist/request/cancel"; // append "/toBeDeletedRequestId"
  static const String acceptWhitelistEntryRequest = "$_profileUrl/whitelist/request/accept"; // append "/toBeAcceptedRequestId"
  static const String declineWhitelistEntryRequest = "$_profileUrl/whitelist/request/decline"; // append "/toBeDeclinedRequestId"
  static const String removeFromWhitelist = "$_profileUrl/whitelist/remove"; // append "/toBeRemovedProfileId"
  static const String leaveWhitelist = "$_profileUrl/whitelist/leave"; // append "/whitelistOwnerProfileId"
  static const String getWhitelist = "$_profileUrl/whitelist/get"; // endpoint takes ?page= and ?limit= url params
  static const String getWhitelistSubscriptions = "$_profileUrl/whitelist/subscriptions/get"; // endpoint takes ?page= and ?limit= url params

  static const String followAUser = "$_profileUrl/follow"; // append "/profileIdToFollow"
  static const String unfollowAUser = "$_profileUrl/unfollow"; // append "/profileIdToUnfollow"
  static const String removeAFollower = "$_profileUrl/followers/remove"; // append "/profileIdToRemove"
  static const String getAProfilesFollowers = "$_profileUrl/followers"; // endpoint takes ?page= and ?limit= url params
  static const String getAProfilesFollowing = "$_profileUrl/following"; // endpoint takes ?page= and ?limit= url params
}
