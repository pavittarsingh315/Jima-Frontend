import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/router/router.gr.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/home/nav_icon.dart';
import 'package:nerajima/pages/browse/nav_icon.dart';
import 'package:nerajima/pages/create/nav_icon.dart';
import 'package:nerajima/pages/inbox/nav_icon.dart';
import 'package:nerajima/pages/profile/nav_icon.dart';

class AppTrunk extends StatelessWidget {
  const AppTrunk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    return AutoTabsScaffold(
      routes: const [
        HomeRouter(),
        BrowseRouter(),
        CreateRouter(),
        InboxRouter(),
        ProfileRouter(),
      ],
      extendBody: true,
      bottomNavigationBuilder: (BuildContext context, TabsRouter tabsRouter) {
        final double safeAreaBottomPadding = MediaQuery.of(context).padding.bottom;
        final double verticalPadding = safeAreaBottomPadding == 0 ? 10 : safeAreaBottomPadding;
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 20, verticalPadding),
          child: Container(
            decoration: BoxDecoration(
              color: darkModeIsOn ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: darkModeIsOn ? darkModeShadowColor : lightModeShadowColor,
                  blurRadius: 11,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SizedBox(
              height: 55,
              width: double.infinity,
              child: Row(
                children: [
                  _navItem(context, HomeBottomNavIcon(tabsRouter: tabsRouter)),
                  _navItem(context, BrowseBottomNavIcon(tabsRouter: tabsRouter)),
                  _navItem(context, CreateBottomNavIcon(tabsRouter: tabsRouter)),
                  _navItem(context, InboxBottomNavIcon(tabsRouter: tabsRouter)),
                  _navItem(context, ProfileBottomNavIcon(tabsRouter: tabsRouter)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _navItem(BuildContext context, Widget child) {
    return SizedBox(
      height: 50,
      width: (MediaQuery.of(context).size.width - 40) / 5, // -40 because of 20 padding from both left and right
      child: child,
    );
  }
}
