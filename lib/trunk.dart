import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/router/router.gr.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/home/nav_icon.dart';
import 'package:nerajima/pages/inbox/nav_icon.dart';
import 'package:nerajima/pages/profile/nav_icon.dart';

import 'package:nerajima/utils/glass_wrapper.dart';

class AppTrunk extends StatelessWidget {
  const AppTrunk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    return AutoTabsScaffold(
      routes: const [
        InboxRouter(),
        HomeRouter(),
        ProfileRouter(),
      ],
      extendBody: true,
      resizeToAvoidBottomInset: false, // false means scaffolds widgets don't resize when keyboard appears
      bottomNavigationBuilder: (BuildContext context, TabsRouter tabsRouter) {
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
            child: SafeArea(
              child: Row(
                children: [
                  _navItem(context, InboxBottomNavIcon(tabsRouter: tabsRouter)),
                  _navItem(context, HomeBottomNavIcon(tabsRouter: tabsRouter)),
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
      width: MediaQuery.of(context).size.width / 3,
      child: child,
    );
  }
}
