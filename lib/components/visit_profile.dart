import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/models/profile_model.dart';
import 'package:nerajima/pages/profile/components/profile_layout.dart';
import 'package:nerajima/utils/api_endpoints.dart';

class VisitProfile extends StatefulWidget {
  final String profileId;
  const VisitProfile({Key? key, required this.profileId}) : super(key: key);

  @override
  State<VisitProfile> createState() => _VisitProfileState();
}

class _VisitProfileState extends State<VisitProfile> {
  Profile profile = loadingProfilePlaceholder;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  Future<void> _getProfile() async {
    try {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      var url = Uri.parse("${ApiEndpoints.getAProfile}/${widget.profileId}");
      Response response = await get(url, headers: {'Content-Type': "application/json", "Token": _userProvider.user.access, "UserId": _userProvider.user.userId});
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        Profile profile2 = Profile.fromJson(resData["data"]["data"]);
        profile = profile2;
        setState(() {});
      } else if (resData["message"] == "Error") {
        profile = notFoundProfilePlaceholder;
        setState(() {});
      }
    } catch (e) {
      profile = notFoundProfilePlaceholder;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfileLayout(
      profileId: profile.profileId,
      username: profile.username,
      name: profile.name,
      bio: profile.bio,
      blacklistMessage: profile.blacklistMessage,
      profilePicture: profile.profilePicture,
      dateJoined: profile.dateJoined,
      numFollowers: profile.numFollowers,
      numWhitelisted: profile.numWhitelisted,
      numFollowing: profile.numFollowing,
      areWhitelisted: profile.areWhitelisted,
      isCurrentUserProfile: profile.profileId == _userProvider.user.profileId,
      areFollowing: profile.areFollowing,
      showBackButton: true, // default to true since this widget is shown in nested routes only
    );
  }
}
