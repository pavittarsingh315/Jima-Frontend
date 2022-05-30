import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<Widget> children;
  const CustomBottomSheet({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    return Container(
      margin: EdgeInsets.only(
        left: size.width * 0.06,
        right: size.width * 0.06,
        bottom: 22,
      ),
      decoration: BoxDecoration(
        color: darkModeIsOn ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(11), bottom: Radius.circular(11)),
      ),
      child: Wrap(
        children: children,
      ),
    );
  }
}
