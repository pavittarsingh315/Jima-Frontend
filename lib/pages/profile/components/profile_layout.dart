import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:custom_nested_scroll_view/custom_nested_scroll_view.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/profile/components/profile_header.dart';
import 'package:nerajima/pages/profile/components/profile_info.dart';
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

// TODO: when creating the blacklist message screen for the whitelist post tab, place a container under the Text widget. This will make it so any emojis won't do the weird choppy render.
class _ProfileLayoutState extends State<ProfileLayout> with SingleTickerProviderStateMixin {
  final double percentScrollForOpacity = 0.75; // % header needs to scroll before its opacity kicks in
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
            SliverPinnedHeader(child: _tabs(context)),
          ];
        },
        body: Container(),
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
        return profileImage(user.user.profilePicture, size);
      },
    );
  }

  Widget _information(BuildContext context) {
    if (!widget.isCurrentUserProfile) {
      return ProfileInformation(
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
          name: user.user.name,
          bio: user.user.bio,
          numFollowers: user.user.numFollowers,
          numWhitelisted: user.user.numWhitelisted,
          numFollowing: user.user.numFollowing,
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
            color: theme.isDarkModeEnabled ? Colors.black : Colors.white,
            boxShadow: [
              BoxShadow(
                color: theme.isDarkModeEnabled ? const Color.fromARGB(255, 22, 22, 22) : Colors.grey.shade400,
                blurRadius: 11,
                spreadRadius: -10,
                offset: const Offset(0, 7),
              ),
            ],
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
