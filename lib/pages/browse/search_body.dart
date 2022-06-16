import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/search_provider.dart';
import 'package:nerajima/components/ui_search_bar.dart';
import 'package:nerajima/pages/browse/search_results.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({Key? key}) : super(key: key);

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  bool showClearButton = false;
  bool showRecents = true;
  bool showResults = false;
  late SearchProvider _searchProvider;
  late UserProvider _userProvider;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    Future.delayed(Duration.zero, () {
      _searchProvider = Provider.of<SearchProvider>(context, listen: false);
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      _searchProvider.getRecentSearches(authToken: _userProvider.user.access, userId: _userProvider.user.userId);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _setShowResults(bool shouldShow) {
    if (showResults == shouldShow) return;
    showResults = shouldShow;
    setState(() {});
  }

  void _checkIfSearchHasValue(_) {
    if (searchController.text != "") {
      if (!showClearButton) {
        showClearButton = true;
        showRecents = false;
        setState(() {});
      }
    } else {
      if (showClearButton) {
        showClearButton = false;
        showRecents = true;
        setState(() {});
      }
    }
    _setShowResults(false); // hide results
  }

  void _performSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (searchController.text != "") {
      _setShowResults(true);
      _searchProvider.addRecentSearch(query: searchController.text, authToken: _userProvider.user.access, userId: _userProvider.user.userId);
      // make the search
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;
    return Center(
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
              onChanged: _checkIfSearchHasValue,
              onEditingComplete: _performSearch,
            ),
            if (showRecents) _clearSearchHistory(context),
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
          showRecents = true;
          showResults = false;
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

  Widget _clearSearchHistory(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, search, child) {
        if (search.recentSearches.isEmpty) {
          return const SizedBox();
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 85,
                child: Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Search History",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    search.clearRecentSearches(authToken: _userProvider.user.access, userId: _userProvider.user.userId);
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text(
                      "Clear",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _recentSearches(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, search, child) {
        return ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: search.recentSearches.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 85,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      searchController.text = search.recentSearches[index];
                      search.addRecentSearch(query: searchController.text, authToken: _userProvider.user.access, userId: _userProvider.user.userId);
                      showResults = true;
                      showClearButton = true;
                      showRecents = false;
                      setState(() {});
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        search.recentSearches[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 15,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      search.removeRecentSearch(index: index, authToken: _userProvider.user.access, userId: _userProvider.user.userId);
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: const Icon(Icons.clear, size: 17, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            );
          },
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
