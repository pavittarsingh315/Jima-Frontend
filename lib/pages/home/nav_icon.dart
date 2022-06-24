import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:nerajima/providers/theme_provider.dart';

class HomeBottomNavIcon extends StatelessWidget {
  final int index = 1;

  const HomeBottomNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: const Icon(
        CupertinoIcons.house_fill,
        size: 27,
        color: true ? primary : Colors.grey,
      ),
    );
  }
}
