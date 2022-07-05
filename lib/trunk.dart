import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'package:nerajima/router.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/inbox/inbox.dart';
import 'package:nerajima/pages/home/home.dart';
import 'package:nerajima/pages/profile/profile.dart';

class AppTrunk extends StatefulWidget {
  static const String route = "/trunk";

  const AppTrunk({Key? key}) : super(key: key);

  @override
  State<AppTrunk> createState() => _AppTrunkState();
}

class _AppTrunkState extends State<AppTrunk> {
  late PersistentTabController _controller;
  final GlobalKey<ProfilePageState> profileKey = GlobalKey<ProfilePageState>();
  bool ranInitialBuild = false; // helper to make sure _mainScreens and _navbarItems are only defined once

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 1);
  }

  late final List<Widget> _mainScreens;
  late final List<PersistentBottomNavBarItem> _navbarItems;

  @override
  Widget build(BuildContext context) {
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    if (!ranInitialBuild) {
      _mainScreens = [const InboxPage(), const HomePage(), ProfilePage(key: profileKey)];
      _navbarItems = [
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.bell_fill),
          inactiveIcon: const Icon(CupertinoIcons.bell),
          activeColorPrimary: primary,
          inactiveColorPrimary: Colors.grey,
          onSelectedTabPressWhenNoScreensPushed: () {},
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.house_fill),
          inactiveIcon: const Icon(CupertinoIcons.house),
          activeColorPrimary: primary,
          inactiveColorPrimary: Colors.grey,
          onSelectedTabPressWhenNoScreensPushed: () {},
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.person_fill),
          inactiveIcon: const Icon(CupertinoIcons.person),
          activeColorPrimary: primary,
          inactiveColorPrimary: Colors.grey,
          onSelectedTabPressWhenNoScreensPushed: () {
            profileKey.currentState!.scrollToTop();
          },
        ),
      ];
      ranInitialBuild = true;
    }

    return PersistentTabView.custom(
      context,
      controller: _controller,
      items: _navbarItems,
      itemCount: _navbarItems.length,
      screens: _mainScreens,
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
      routeAndNavigatorSettings: const CustomWidgetRouteAndNavigatorSettings(
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
      navBarHeight: navBarHeight(context),
      bottomScreenMargin: 0,
      backgroundColor: darkModeIsOn ? Colors.black : Colors.white,
      customWidget: (NavBarEssentials navBarEssentials) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 0.1,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          child: Stack(
            children: [
              AnimatedPadding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * (_controller.index / _navbarItems.length)),
                duration: const Duration(milliseconds: 300), // duration same as ScreenTransitionAnimation
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width / _navbarItems.length,
                  color: primary,
                ),
              ),
              Row(
                children: _navbarItems.map((item) {
                  int index = _navbarItems.indexOf(item);
                  return _navItem(context, navBarEssentials, index, _controller.index == index, item);
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _navItem(BuildContext context, NavBarEssentials navBarEssentials, int index, bool isActive, PersistentBottomNavBarItem item) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / _navbarItems.length, // length of navbarItems
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
          padding: EdgeInsets.only(top: (navBarHeight(context)) * 0.22), // twenty-two percent of navbar height
          child: IconTheme(
            data: IconThemeData(size: 27, color: isActive ? item.activeColorPrimary : item.inactiveColorPrimary),
            child: isActive ? item.icon : item.inactiveIcon!,
          ),
        ),
      ),
    );
  }
}
