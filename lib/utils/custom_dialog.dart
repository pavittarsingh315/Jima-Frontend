import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';

class CustomDialog extends StatelessWidget {
  final String message;
  final List<String> actionLabels;
  final List<VoidCallback?> actionCallbacks;
  final List<Color?> actionColors;
  final double height, topPadding;

  const CustomDialog({
    Key? key,
    required this.message,
    required this.actionLabels,
    required this.actionCallbacks,
    required this.actionColors,
    this.topPadding = 40,
    this.height = 160,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context, listen: false).isDarkModeEnabled;

    final List<Widget> showActions = actionLabels.asMap().entries.map(
      (label) {
        int index = label.key;
        final bool callbackIsPresent = actionCallbacks.length > index; // callback is present for each index less than its length
        final bool colorIsPresent = actionColors.length > index; // color is present for each index less than its length
        return Expanded(
          child: TextButton(
            onPressed: callbackIsPresent ? actionCallbacks[index] : () {},
            style: ButtonStyle(overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Colors.transparent)),
            child: Text(
              label.value,
              style: TextStyle(color: colorIsPresent ? actionColors[index] : Colors.grey, fontSize: 15),
            ),
          ),
        );
      },
    ).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: height,
        width: 11,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: darkModeIsOn ? Colors.grey[900] : Colors.white,
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: topPadding, left: 20, right: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: showActions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
