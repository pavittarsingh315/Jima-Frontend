import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:nerajima/pages/browse/search_body.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SearchBody(),
      floatingActionButton: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Padding(
            padding: EdgeInsets.only(bottom: isKeyboardVisible ? 0 : 50),
            child: FloatingActionButton(
              onPressed: () {
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
