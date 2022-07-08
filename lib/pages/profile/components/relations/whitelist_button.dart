import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/profile/components/relations/add_to_whitelist.dart';

class WhitelistButton extends StatelessWidget {
  const WhitelistButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 500),
      transitionType: ContainerTransitionType.fadeThrough,
      middleColor: darkModeIsOn ? Colors.black : Colors.white,
      closedElevation: 0,
      closedColor: primary,
      closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      closedBuilder: (context, _) {
        return const Padding(
          padding: EdgeInsets.all(15.0),
          child: Icon(
            CupertinoIcons.person_add_solid,
            color: Colors.white,
          ),
        );
      },
      openElevation: 0,
      openShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      openColor: darkModeIsOn ? Colors.black : Colors.white,
      openBuilder: (context, _) {
        return const AddToWhitelist();
      },
    );
  }
}
