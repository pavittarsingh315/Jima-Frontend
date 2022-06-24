import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:nerajima/providers/theme_provider.dart';

class InboxBottomNavIcon extends StatelessWidget {
  final int index = 0; // index of inbox in navbar

  const InboxBottomNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: const Icon(
        CupertinoIcons.bell_fill,
        size: 27,
        color: true ? primary : Colors.grey,
      ),
    );
  }
}
