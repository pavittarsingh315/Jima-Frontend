import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nerajima/providers/theme_provider.dart';

enum Button { back, settings, more }

class HeaderButtons extends StatelessWidget {
  final Button buttonType;
  const HeaderButtons({Key? key, required this.buttonType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (buttonType == Button.back) {
      return _wrapper(
        onPress: () {},
        icon: FontAwesomeIcons.chevronLeft,
      );
    } else if (buttonType == Button.settings) {
      return _wrapper(
        onPress: () {},
        icon: FontAwesomeIcons.gear,
      );
    } else {
      return _wrapper(
        onPress: () {},
        icon: FontAwesomeIcons.ellipsis,
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
          size: 18,
        ),
      ),
    );
  }
}
