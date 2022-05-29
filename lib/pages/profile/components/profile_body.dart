import 'package:flutter/material.dart';
import 'package:nerajima/pages/profile/components/archives.dart';
import 'package:nerajima/pages/profile/components/private_posts.dart';

import 'package:nerajima/pages/profile/components/public_posts.dart';

class ProfileBody extends StatelessWidget {
  final TabController controller;
  final String profileId, profileBlacklistMessage;
  final bool areWhitelisted;

  const ProfileBody({
    Key? key,
    required this.controller,
    required this.profileId,
    required this.profileBlacklistMessage,
    required this.areWhitelisted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      children: [
        PublicPosts(profileId: profileId),
        PrivatePosts(profileId: profileId, profileBlacklistMessage: profileBlacklistMessage, areWhitelisted: areWhitelisted),
        if (controller.length == 3) const Archives(),
      ],
    );
  }
}
