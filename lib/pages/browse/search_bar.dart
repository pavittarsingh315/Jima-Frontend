import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:nerajima/components/ui_search_bar.dart';

class SearchBar extends StatefulWidget {
  final Function(bool) setShowRecents, setShowResults;
  final TextEditingController searchController;
  final VoidCallback onEditingComplete;
  const SearchBar({
    Key? key,
    required this.setShowRecents,
    required this.setShowResults,
    required this.searchController,
    required this.onEditingComplete,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClearButton = false;

  void checkIfSearchHasValue(_) {
    if (widget.searchController.text != "") {
      if (!showClearButton) {
        showClearButton = true;
        setState(() {});
        widget.setShowRecents(false); // show suggestions
      }
    } else {
      if (showClearButton) {
        showClearButton = false;
        setState(() {});
        widget.setShowRecents(true); // show recents
      }
    }
    widget.setShowResults(false); // hide results
  }

  void makeSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (widget.searchController.text != "") {
      widget.setShowResults(true); // show results
      widget.onEditingComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaPadding = MediaQuery.of(context).padding;
    return UISearchBar(
      hintText: "Search",
      autofocus: true,
      controller: widget.searchController,
      padding: EdgeInsets.fromLTRB(11, safeAreaPadding.top, 11, 4),
      suffix: _clearButton(context),
      onChanged: checkIfSearchHasValue,
      onEditingComplete: makeSearch,
    );
  }

  Widget? _clearButton(BuildContext context) {
    if (showClearButton) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          HapticFeedback.lightImpact();
          widget.searchController.text = "";
          showClearButton = false;
          setState(() {});
          widget.setShowRecents(true); // show recents
          widget.setShowResults(false);
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
}
