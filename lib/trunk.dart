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

  @override
  Widget build(BuildContext context) {
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    return PersistentTabView.custom(
      context,
      controller: _controller,
      itemCount: mainScreens.length,
      stateManagement: true,
      popAllScreensOnTapOfSelectedTab: true,
      handleAndroidBackButtonPress: true,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 300),
      ),
      screens: mainScreens,
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
              children: [
                _navItem(context, 0, CupertinoIcons.bell_fill, CupertinoIcons.bell),
                _navItem(context, 1, CupertinoIcons.house_fill, CupertinoIcons.house),
                _navItem(context, 2, CupertinoIcons.person_fill, CupertinoIcons.person),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _navItem(BuildContext context, int index, IconData activeIcon, IconData inactiveIcon) {
    final bool isActive = _controller.index == index;
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width / mainScreens.length,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (isActive) {
            HapticFeedback.mediumImpact();
          } else {
            _controller.index = index;
            setState(() {});
          }
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Icon(
            isActive ? activeIcon : inactiveIcon,
            size: 27,
            color: isActive ? primary : Colors.grey,
          ),
        ),
      ),
    );
  }
}
