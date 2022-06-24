import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:nerajima/pages/browse/search_body.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SearchBody(),
      floatingActionButton: _backButton(context),
    );
  }

  Widget _backButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Icon(
            CupertinoIcons.xmark,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
