import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/inbox/inbox.dart';
import 'package:nerajima/pages/home/home.dart';
import 'package:nerajima/pages/profile/profile.dart';
import 'package:nerajima/utils/glass_wrapper.dart';

class AppTrunk extends StatefulWidget {
  static const String route = "/trunk";

  const AppTrunk({Key? key}) : super(key: key);

  @override
  State<AppTrunk> createState() => _AppTrunkState();
}

class _AppTrunkState extends State<AppTrunk> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 1);
  }

  final List<Widget> mainScreens = const [InboxPage(), HomePage(), ProfilePage()];

  final List<PersistentBottomNavBarItem> _navbarItems = [
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.bell_fill),
      inactiveIcon: const Icon(CupertinoIcons.bell),
      activeColorPrimary: primary,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.house_fill),
      inactiveIcon: const Icon(CupertinoIcons.house),
      activeColorPrimary: primary,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.person_fill),
      inactiveIcon: const Icon(CupertinoIcons.person),
      activeColorPrimary: primary,
      inactiveColorPrimary: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    return PersistentTabView.custom(
      context,
      controller: _controller,
      items: _navbarItems,
      itemCount: _navbarItems.length,
      screens: mainScreens,
      stateManagement: true,
      popAllScreensOnTapOfSelectedTab: true,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: false,
      hideNavigationBarWhenKeyboardShows: false,
      confineInSafeArea: false,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 300),
      ),
      navBarHeight: bottomPadding + 50, // 50 is the height of each _navItem
      bottomScreenMargin: 50,
      customWidget: (NavBarEssentials navBarEssentials) {
        return GlassWrapper(
          child: Container(
            decoration: BoxDecoration(
              color: darkModeIsOn ? Colors.black.withOpacity(glassOpacity) : Colors.white.withOpacity(glassOpacity),
              border: Border(
                top: BorderSide(
                  width: 0.1,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            child: Row(
              children: _navbarItems.map((item) {
                int index = _navbarItems.indexOf(item);
                return _navItem(context, navBarEssentials, index, _controller.index == index, item);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _navItem(BuildContext context, NavBarEssentials navBarEssentials, int index, bool isActive, PersistentBottomNavBarItem item) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    return SizedBox(
      width: MediaQuery.of(context).size.width / _navbarItems.length,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (isActive) {
            HapticFeedback.mediumImpact();
          } else {
            HapticFeedback.lightImpact();
          }
          setState(() {
            navBarEssentials.onItemSelected!(index);
          });
        },
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: (bottomPadding + 50) * 0.22), // twenty-two percent of navbar height
          child: IconTheme(
            data: IconThemeData(size: 27, color: isActive ? item.activeColorPrimary : item.inactiveColorPrimary),
            child: isActive ? item.icon : item.inactiveIcon!,
          ),
        ),
      ),
    );
  }
}
