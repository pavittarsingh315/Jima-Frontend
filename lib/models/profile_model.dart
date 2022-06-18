import 'package:nerajima/utils/utils.dart';

class Profile {
  final String profileId, username, name, bio, blacklistMessage, profilePicture, dateJoined;
  final int numFollowers, numWhitelisted, numFollowing;
  final bool areWhitelisted, areFollowing;

  Profile({
    required this.profileId,
    required this.username,
    required this.name,
    required this.bio,
    required this.blacklistMessage,
    required this.profilePicture,
    required this.dateJoined,
    required this.numFollowers,
    required this.numWhitelisted,
    required this.numFollowing,
    required this.areWhitelisted,
    required this.areFollowing,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final DateTime localTime = DateTime.parse(json["profile"]["createdDate"]).toLocal();
    final String dateJoined = "${intToMonth(monthInt: localTime.month)} ${localTime.day.toString()}, ${localTime.year.toString()}";
    return Profile(
      profileId: json["profile"]["profileId"],
      username: json["profile"]["username"],
      name: json["profile"]["name"],
      bio: json["profile"]["bio"],
      blacklistMessage: json["profile"]["blacklistMessage"],
      profilePicture: json["profile"]["profilePicture"],
      dateJoined: dateJoined,
      numFollowers: json["profile"]["numFollowers"],
      numWhitelisted: json["profile"]["numWhitelisted"],
      numFollowing: json["profile"]["numFollowing"],
      areWhitelisted: json[""], // TODO: fill this in with name of json field
      areFollowing: json[""], // TODO: fill this in with name of json field
    );
  }
}

Profile loadingProfilePlaceholder = Profile(
  profileId: "123456789",
  username: "",
  name: "",
  bio: "",
  blacklistMessage: "",
  profilePicture: "https://nerajima.s3.us-west-1.amazonaws.com/default.jpg",
  dateJoined: "",
  numFollowers: 0,
  numWhitelisted: 0,
  numFollowing: 0,
  areWhitelisted: false,
  areFollowing: false,
);

Profile notFoundProfilePlaceholder = Profile(
  profileId: "123456789",
  username: "Easter Egg Again?",
  name: "User not found!",
  bio: "",
  blacklistMessage: "Easter Egg?",
  profilePicture: "https://nerajima.s3.us-west-1.amazonaws.com/default.jpg",
  dateJoined: "June 17, 2022",
  numFollowers: 11,
  numWhitelisted: 12,
  numFollowing: 22,
  areWhitelisted: false,
  areFollowing: false,
);
