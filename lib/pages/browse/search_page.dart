import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:nerajima/pages/browse/search_body.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isClosing = false;
  double currentFABPadding = 0; // autofocus == true => isKeyboardVisible == true => padding == 0

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SearchBody(),
      floatingActionButton: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          if (!isClosing) currentFABPadding = isKeyboardVisible ? 0 : 50; // if screen is closing, don't change the padding
          return Padding(
            padding: EdgeInsets.only(bottom: currentFABPadding),
            child: FloatingActionButton(
              onPressed: () {
                isClosing = true;
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop();
              },
              backgroundColor: Colors.red,
              child: const Icon(
                CupertinoIcons.xmark,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
