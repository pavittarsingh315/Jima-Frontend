import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:custom_nested_scroll_view/custom_nested_scroll_view.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/pages/profile/components/profile_header.dart';
import 'package:nerajima/pages/profile/components/profile_info.dart';
import 'package:nerajima/pages/profile/components/profile_tabs.dart';
import 'package:nerajima/pages/profile/components/profile_body.dart';
import 'package:nerajima/pages/profile/components/profile_picture.dart';
import 'package:nerajima/pages/profile/components/header_buttons.dart';
import 'package:nerajima/utils/opacity_slope_calculator.dart';

class ProfileLayout extends StatefulWidget {
  final String profileId, username, name, bio, blacklistMessage, profilePicture, dateJoined;
  final int numFollowers, numWhitelisted, numFollowing;
  final bool areWhitelisted, isCurrentUserProfile, showBackButton;

  const ProfileLayout({
    Key? key,
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
    required this.isCurrentUserProfile,
    required this.showBackButton,
  }) : super(key: key);

  @override
  State<ProfileLayout> createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> with SingleTickerProviderStateMixin {
  final double percentScrollForOpacity = 0.75; // % header needs to scroll before its opacity kicks in
  final GlobalKey infoKey = GlobalKey();
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.isCurrentUserProfile ? 3 : 2, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 750), curve: Curves.decelerate);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double minExtent = 103, maxExtent = size.height / 2.2;
    final double opacityIncreaseSlope = calculateOpacitySlope(maxOpacity: (maxExtent - minExtent) * (1 - percentScrollForOpacity));
    return Scaffold(
      body: CustomNestedScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        overscrollType: CustomOverscroll.outer,
        headerSliverBuilder: (context, outerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              pinned: true,
              delegate: ProfileHeaderDelegate(
                minExtentParam: minExtent,
                maxExtentParam: maxExtent,
                percentScrollForOpacity: percentScrollForOpacity,
                opacityIncreaseSlope: opacityIncreaseSlope,
                background: _background(context),
                username: widget.username,
                dateJoined: widget.dateJoined,
                isCurrentUserProfile: widget.isCurrentUserProfile,
                leading: widget.showBackButton ? const HeaderButtons(buttonType: Button.back) : null,
                action: widget.isCurrentUserProfile ? const HeaderButtons(buttonType: Button.settings) : const HeaderButtons(buttonType: Button.more),
                onHeaderTap: scrollToTop,
                onStrech: null,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 20),
                  _information(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            SliverPinnedHeader(
              child: ProfileTabs(
                tabController: _tabController,
                scrollController: _scrollController,
                infoKey: infoKey,
              ),
            ),
          ];
        },
        body: ProfileBody(
          controller: _tabController,
          profileId: widget.profileId, // no Consumer because id won't change
          profileBlacklistMessage: widget.blacklistMessage, // no Consumer because user won't see their own blacklist message
          areWhitelisted: widget.areWhitelisted, // no Consumer because it won't change.
        ),
      ),
    );
  }

  Widget _background(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!widget.isCurrentUserProfile) {
      return profileImage(widget.profilePicture, size);
    }

    return Consumer<UserProvider>(
      builder: (context, user, child) {
        if (user.newProfilePicture != null) {
          return Image.file(
            user.newProfilePicture!,
            fit: BoxFit.cover,
          );
        }
        return cachedProfileImage(user.user.profilePicture, size);
      },
    );
  }

  Widget _information(BuildContext context) {
    if (!widget.isCurrentUserProfile) {
      return ProfileInformation(
        key: infoKey,
        name: widget.name,
        bio: widget.bio,
        numFollowers: widget.numFollowers,
        numWhitelisted: widget.numWhitelisted,
        numFollowing: widget.numFollowing,
      );
    }

    return Consumer<UserProvider>(
      builder: (context, user, child) {
        return ProfileInformation(
          key: infoKey,
          name: user.user.name,
          bio: user.user.bio,
          numFollowers: user.user.numFollowers,
          numWhitelisted: user.user.numWhitelisted,
          numFollowing: user.user.numFollowing,
        );
      },
    );
  }
}
