class SearchUser {
  late final String profileId, username, name, miniProfilePicture;

  SearchUser({
    required this.profileId,
    required this.username,
    required this.name,
    required this.miniProfilePicture,
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    return SearchUser(
      profileId: json['profileId'],
      username: json['username'],
      name: json['name'],
      miniProfilePicture: json['miniProfilePicture'],
    );
  }
}
