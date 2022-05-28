import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/router/router.gr.dart';

class InboxBottomNavIcon extends StatelessWidget {
  final TabsRouter tabsRouter;
  final int index = 3; // index of inbox in navbar

  const InboxBottomNavIcon({Key? key, required this.tabsRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == tabsRouter.activeIndex;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (isActive) {
          if (tabsRouter.canPopSelfOrChildren) {
            HapticFeedback.lightImpact();
            context.router.popTop();
          }
          return;
        }
        HapticFeedback.lightImpact();
        tabsRouter.setActiveIndex(index);
      },
      onLongPress: () {
        if (isActive && tabsRouter.canPopSelfOrChildren) {
          HapticFeedback.mediumImpact();
          context.router.navigate(const InboxRoute());
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: FaIcon(
          FontAwesomeIcons.solidEnvelope,
          size: 23.5,
          color: isActive ? primary : Colors.grey,
        ),
      ),
    );
  }
}
