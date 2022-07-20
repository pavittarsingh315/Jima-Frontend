import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:nerajima/components/ui_search_bar.dart';
import 'package:nerajima/providers/theme_provider.dart';

class AddToWhitelist extends StatefulWidget {
  const AddToWhitelist({Key? key}) : super(key: key);

  @override
  State<AddToWhitelist> createState() => _AddToWhitelistState();
}

class _AddToWhitelistState extends State<AddToWhitelist> {
  Timer? searchTimer;
  final TextEditingController searchController = TextEditingController();
  bool isClosing = false, showClearButton = false, showSuggestions = false;
  double currentFABPadding = 0; // autofocus == true => isKeyboardVisible == true => padding == 0

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _checkIfSearchHasValue() {
    if (searchController.text != "") {
      if (!showClearButton) {
        showClearButton = true;
        showSuggestions = true;
        setState(() {});
      }
    } else {
      if (showClearButton) {
        showClearButton = false;
        showSuggestions = false;
        setState(() {});
      }
    }
  }

  void _onSearchTypingStop(value) {
    if (searchTimer != null) searchTimer?.cancel();
    setState(() {
      searchTimer = Timer(const Duration(milliseconds: 500), () {
        // _searchProvider.makeSearch(query: value, authToken: _userProvider.user.access, userId: _userProvider.user.userId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;
    return Scaffold(
      floatingActionButton: _closeButton(context),
      body: Center(
        child: SizedBox(
          width: size.width * 0.95,
          child: Column(
            children: [
              UISearchBar(
                autofocus: true,
                hintText: "Search",
                controller: searchController,
                padding: EdgeInsets.only(top: safeAreaPadding.top, bottom: 6),
                suffix: _clearSearchBar(context),
                onChanged: (v) {
                  _checkIfSearchHasValue();
                  _onSearchTypingStop(v);
                },
              ),
              if (!showSuggestions)
                _noSearchValue(context)
              else
                Container(
                  height: 100,
                  color: Colors.blue,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _clearSearchBar(BuildContext context) {
    if (showClearButton) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          HapticFeedback.lightImpact();
          searchController.text = "";
          showClearButton = false;
          showSuggestions = false;
          setState(() {});
        },
        child: const Icon(
          CupertinoIcons.clear_circled,
          color: Colors.grey,
          size: 16,
        ),
      );
    }
    return null;
  }

  Widget _noSearchValue(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              AnimatedContainer(
                curve: Curves.linear,
                duration: const Duration(milliseconds: 50),
                alignment: Alignment.center,
                constraints: BoxConstraints(maxHeight: constraints.maxHeight - navBarHeight(context)),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    Icon(CupertinoIcons.search, size: 50),
                    SizedBox(height: 10),
                    Text(
                      "Search Users",
                      style: TextStyle(fontSize: 35),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text("Search for a user you would like to whitelist.", textAlign: TextAlign.center),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (!isClosing) currentFABPadding = isKeyboardVisible ? 0 : 50; // if screen is closing, don't change the padding
        return AnimatedPadding(
          padding: EdgeInsets.only(bottom: currentFABPadding),
          duration: const Duration(milliseconds: 400),
          curve: Curves.linear,
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
    );
  }
}
