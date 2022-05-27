import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nerajima/providers/theme_provider.dart';

class BrowseBottomNavIcon extends StatelessWidget {
  final TabsRouter tabsRouter;
  final int index = 1; // index of browse in navbar

  const BrowseBottomNavIcon({Key? key, required this.tabsRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == tabsRouter.activeIndex;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      onLongPress: () {},
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: FaIcon(
          FontAwesomeIcons.magnifyingGlass,
          size: 27,
          color: isActive ? primary : Colors.grey,
        ),
      ),
    );
  }
}