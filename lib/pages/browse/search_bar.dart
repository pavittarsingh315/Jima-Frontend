import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:nerajima/components/ui_search_bar.dart';

class SearchBar extends StatefulWidget {
  final VoidCallback setShowRecents;
  const SearchBar({Key? key, required this.setShowRecents}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClearButton = false;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void checkIfSearchHasValue(_) {
    if (searchController.text != "") {
      if (!showClearButton) {
        showClearButton = true;
        setState(() {});
        widget.setShowRecents();
      }
    } else {
      if (showClearButton) {
        showClearButton = false;
        setState(() {});
        widget.setShowRecents();
      }
    }
  }

  void makeSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (searchController.text != "") {
      // make search
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaPadding = MediaQuery.of(context).padding;
    return UISearchBar(
      hintText: "Search",
      autofocus: true,
      controller: searchController,
      padding: EdgeInsets.fromLTRB(11, safeAreaPadding.top, 11, 11),
      suffix: _clearButton(context),
      onChanged: checkIfSearchHasValue,
    );
  }

  Widget? _clearButton(BuildContext context) {
    if (showClearButton) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          searchController.text = "";
          showClearButton = false;
          setState(() {});
          widget.setShowRecents();
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
