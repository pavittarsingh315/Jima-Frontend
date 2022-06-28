import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/pages/profile/components/profile_layout.dart';

// TODO: set areWhitelisted to true.
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 750), curve: Curves.decelerate);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    return ProfileLayout(
      profileId: userProvider.user.profileId,
      username: userProvider.user.username,
      name: userProvider.user.name,
      bio: userProvider.user.bio,
      blacklistMessage: userProvider.user.blacklistMessage,
      profilePicture: userProvider.user.profilePicture,
      dateJoined: userProvider.user.dateJoined,
      numFollowers: userProvider.user.numFollowers,
      numWhitelisted: userProvider.user.numWhitelisted,
      numFollowing: userProvider.user.numFollowing,
      areWhitelisted: false, // default true for user's own profile
      isCurrentUserProfile: true, // default true for user's own profile. Otherwise, profileId == userProvider.user.profileId
      areFollowing: true, // value does not matter when isCurrentUserProfile == true
      showBackButton: false, // profile is root of ProfileRouter so it will not show back button
      scrollController: _scrollController,
      onHeaderTap: scrollToTop,
    );
  }
}
