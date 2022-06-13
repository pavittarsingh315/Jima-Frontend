import 'package:flutter/material.dart';

import 'package:nerajima/pages/browse/search_bar.dart';
import 'package:nerajima/pages/browse/search_results.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({Key? key}) : super(key: key);

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  bool showRecents = true;
  bool showResults = false;

  void setShowRecents(bool shouldShow) {
    if (showRecents == shouldShow) return;
    showRecents = shouldShow;
    setState(() {});
  }

  void setShowResults(bool shouldShow) {
    if (showResults == shouldShow) return;
    showResults = shouldShow;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(setShowRecents: setShowRecents, setShowResults: setShowResults),
        if (showResults)
          const Expanded(child: SearchResults())
        else
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: showRecents ? _recentSearches(context) : _suggestions(context),
            ),
          ),
      ],
    );
  }

  Widget _recentSearches(BuildContext context) {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: 60,
      itemBuilder: (context, index) {
        return Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: index % 2 == 0 ? Colors.green.shade100 : Colors.pink.shade100,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text("Recent ${index.toString()}"),
        );
      },
    );
  }

  Widget _suggestions(BuildContext context) {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: 60,
      itemBuilder: (context, index) {
        return Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: index % 2 == 0 ? Colors.blue.shade100 : Colors.pink.shade100,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text("Suggestion ${index.toString()}"),
        );
      },
    );
  }
}
