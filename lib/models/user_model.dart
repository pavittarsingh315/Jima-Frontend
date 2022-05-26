import 'package:nerajima/utils/utils.dart';

class User {
  final String access, refresh, userId, profileId, dateJoined;
  late String username, name, bio, blacklistMessage, profilePicture, miniProfilePicture;
  late int numFollowers, numWhitelisted, numFollowing;

  User({
    required this.access,
    required this.refresh,
    required this.userId,
    required this.profileId,
    required this.dateJoined,
    required this.username,
    required this.name,
    required this.bio,
    required this.blacklistMessage,
    required this.profilePicture,
    required this.miniProfilePicture,
    required this.numFollowers,
    required this.numWhitelisted,
    required this.numFollowing,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final DateTime localTime = DateTime.parse(json["profile"]["createdDate"]).toLocal();
    final String dateJoined = "${intToMonth(monthInt: localTime.month)} ${localTime.day.toString()}, ${localTime.year.toString()}";
    return User(
      access: json["access"],
      refresh: json["refresh"],
      userId: json["profile"]["userId"],
      profileId: json["profile"]["profileId"],
      dateJoined: dateJoined,
      username: json["profile"]["username"],
      name: json["profile"]["name"],
      bio: json["profile"]["bio"],
      blacklistMessage: json["profile"]["blacklistMessage"],
      profilePicture: json["profile"]["profilePicture"],
      miniProfilePicture: json["profile"]["miniProfilePicture"],
      numFollowers: json["profile"]["numFollowers"],
      numWhitelisted: json["profile"]["numWhitelisted"],
      numFollowing: json["profile"]["numFollowing"],
    );
  }
}
