import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';

class ProfileTabs extends StatefulWidget {
  final TabController tabController;
  final ScrollController scrollController;
  final GlobalKey infoKey;

  const ProfileTabs({
    Key? key,
    required this.tabController,
    required this.scrollController,
    required this.infoKey,
  }) : super(key: key);

  @override
  State<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs> {
  final GlobalKey tabsKey = GlobalKey();
  bool showGlassTabs = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(manageTabAppearance);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(manageTabAppearance);
    super.dispose();
  }

  void manageTabAppearance() {
    final headerHeight = MediaQuery.of(context).size.height / 2.2;
    final profileInfoHeight = (widget.infoKey.currentContext?.findRenderObject() as RenderBox).size.height;
    final tabsHeight = (tabsKey.currentContext?.findRenderObject() as RenderBox).size.height;
    final scrollPosition = widget.scrollController.position.pixels;
    if ((scrollPosition + tabsHeight + 20) >= headerHeight + profileInfoHeight) {
      // Tabs are at top of screen.
      if (!showGlassTabs) {
        showGlassTabs = true;
        setState(() {});
      }
    } else {
      // Tabs are NOT at top of screen.
      if (showGlassTabs) {
        showGlassTabs = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double sigma = showGlassTabs ? glassSigmaValue : 0;
    final int tabLength = widget.tabController.length;
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) {
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
            child: Container(
              key: tabsKey,
              height: 38,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 0.1, color: Colors.grey.shade400),
                  bottom: BorderSide(width: 0.1, color: Colors.grey.shade400),
                ),
                color: theme.isDarkModeEnabled ? Colors.black.withOpacity(glassOpacity) : Colors.white.withOpacity(glassOpacity),
              ),
              child: TabBar(
                controller: widget.tabController,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(width: 0.66, color: primary),
                  insets: EdgeInsets.symmetric(horizontal: 33.0),
                ),
                tabs: [
                  Tab(icon: Icon(CupertinoIcons.lock_open, size: 21, color: theme.isDarkModeEnabled ? Colors.white : Colors.black)),
                  Tab(icon: Icon(CupertinoIcons.lock, size: 21, color: theme.isDarkModeEnabled ? Colors.white : Colors.black)),
                  if (tabLength == 3) Tab(icon: Icon(CupertinoIcons.cube_box, size: 21, color: theme.isDarkModeEnabled ? Colors.white : Colors.black))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
