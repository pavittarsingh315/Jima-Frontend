import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:custom_nested_scroll_view/custom_nested_scroll_view.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/profile/components/profile_header.dart';
import 'package:nerajima/pages/profile/components/profile_info.dart';
import 'package:nerajima/pages/profile/components/profile_body.dart';
import 'package:nerajima/pages/profile/components/profile_picture.dart';
import 'package:nerajima/pages/profile/components/header_buttons.dart';
import 'package:nerajima/utils/opacity_slope_calculator.dart';

// TODO: keep track of the farthest position the user scrolls. Then once the position decreases say 50px, show an FAB that'll take the user back to that farthest position. you can access scroll position with scroll controller
class ProfileLayout extends StatefulWidget {
  final String profileId, username, name, bio, blacklistMessage, profilePicture, dateJoined;
  final int numFollowers, numWhitelisted, numFollowing;
  final bool areWhitelisted, isCurrentUserProfile, areFollowing, showBackButton;
  final ScrollController scrollController;
  final VoidCallback? onHeaderTap;

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
    required this.areFollowing,
    required this.showBackButton,
    required this.scrollController,
    required this.onHeaderTap,
  }) : super(key: key);

  @override
  State<ProfileLayout> createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> with TickerProviderStateMixin {
  final double percentScrollForOpacity = 0.75; // % header needs to scroll before its opacity kicks in
  final GlobalKey infoKey = GlobalKey();
  late TabController _tabController = TabController(length: widget.isCurrentUserProfile ? 3 : 2, vsync: this);

  @override
  void didUpdateWidget(covariant ProfileLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tabController = TabController(length: widget.isCurrentUserProfile ? 3 : 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double minExtent = 103, maxExtent = size.height / 2.2;
    final double opacityIncreaseSlope = calculateOpacitySlope(maxOpacity: (maxExtent - minExtent) * (1 - percentScrollForOpacity));
    return Scaffold(
      body: CustomNestedScrollView(
        controller: widget.scrollController,
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
                onHeaderTap: widget.onHeaderTap,
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
              child: _tabs(context),
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
        profileId: widget.profileId,
        username: widget.username,
        name: widget.name,
        bio: widget.bio,
        numFollowers: widget.numFollowers,
        numWhitelisted: widget.numWhitelisted,
        numFollowing: widget.numFollowing,
        isCurrentUserProfile: widget.isCurrentUserProfile,
        areFollowing: widget.areFollowing,
      );
    }

    return Consumer<UserProvider>(
      builder: (context, user, child) {
        return ProfileInformation(
          key: infoKey,
          profileId: user.user.profileId,
          username: user.user.username,
          name: user.user.name,
          bio: user.user.bio,
          numFollowers: user.user.numFollowers,
          numWhitelisted: user.user.numWhitelisted,
          numFollowing: user.user.numFollowing,
          isCurrentUserProfile: widget.isCurrentUserProfile,
          areFollowing: widget.areFollowing,
        );
      },
    );
  }

  Widget _tabs(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) {
        return Container(
          height: 38,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 0.2, color: Colors.grey.shade400),
              bottom: BorderSide(width: 0.2, color: Colors.grey.shade400),
            ),
            color: theme.isDarkModeEnabled ? Colors.black : Colors.white,
          ),
          child: TabBar(
            controller: _tabController,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 0.66, color: primary),
              insets: EdgeInsets.symmetric(horizontal: 33.0),
            ),
            tabs: [
              Tab(icon: Icon(CupertinoIcons.lock_open, size: 21, color: theme.isDarkModeEnabled ? Colors.white : Colors.black)),
              Tab(icon: Icon(CupertinoIcons.lock, size: 21, color: theme.isDarkModeEnabled ? Colors.white : Colors.black)),
              if (_tabController.length == 3) Tab(icon: Icon(CupertinoIcons.cube_box, size: 21, color: theme.isDarkModeEnabled ? Colors.white : Colors.black))
            ],
          ),
        );
      },
    );
  }
}
