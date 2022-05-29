import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/profile/settings.dart';

enum Button { back, settings, more }

class HeaderButtons extends StatelessWidget {
  final Button buttonType;
  const HeaderButtons({Key? key, required this.buttonType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (buttonType == Button.back) {
      return _wrapper(
        onPress: () {},
        icon: CupertinoIcons.chevron_back,
      );
    } else if (buttonType == Button.settings) {
      return _wrapper(
        onPress: () {
          context.router.pushNativeRoute(
            SwipeablePageRoute(
              builder: (context) => const SettingsPage(),
            ),
          );
        },
        icon: CupertinoIcons.gear,
      );
    } else {
      return _wrapper(
        onPress: () {},
        icon: Icons.more_horiz_rounded,
      );
    }
  }

  Widget _wrapper({required VoidCallback onPress, required IconData icon}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        HapticFeedback.mediumImpact();
        onPress();
      },
      child: SizedBox(
        height: 40,
        width: 40,
        child: Icon(
          icon,
          color: primary,
          size: 20,
        ),
      ),
    );
  }
}
