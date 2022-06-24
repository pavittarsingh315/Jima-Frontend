import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

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
        onPress: () {
          Navigator.of(context).pop();
        },
        icon: CupertinoIcons.chevron_back,
      );
    } else if (buttonType == Button.settings) {
      return _wrapper(
        onPress: () {
          pushNewScreenWithRouteSettings(
            context,
            screen: const SettingsPage(),
            settings: const RouteSettings(name: SettingsPage.route),
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
