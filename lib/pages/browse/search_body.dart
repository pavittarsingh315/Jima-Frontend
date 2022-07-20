import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/search_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/browse/search_results.dart';
import 'package:nerajima/components/ui_search_bar.dart';
import 'package:nerajima/components/profile_preview_card.dart';
import 'package:nerajima/components/loading_spinner.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({Key? key}) : super(key: key);

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  Timer? searchTimer;
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

  void _checkIfSearchHasValue() {
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

  void _onSearchTypingStop(value) {
    if (searchTimer != null) searchTimer?.cancel();
    setState(() {
      searchTimer = Timer(const Duration(milliseconds: 500), () {
        _searchProvider.makeSearch(query: value, authToken: _userProvider.user.access, userId: _userProvider.user.userId);
      });
    });
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
              onChanged: (v) {
                _checkIfSearchHasValue();
                _onSearchTypingStop(v);
              },
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
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  HapticFeedback.lightImpact();
                  search.clearRecentSearches(authToken: _userProvider.user.access, userId: _userProvider.user.userId);
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 22, right: 5),
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    "Clear",
                    style: TextStyle(color: Colors.red),
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
        return Scrollbar(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: search.recentSearches.length,
            padding: EdgeInsets.only(bottom: navBarHeight(context)),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        searchController.text = search.recentSearches[index];
                        search.addRecentSearch(query: searchController.text, authToken: _userProvider.user.access, userId: _userProvider.user.userId);
                        // make search suggestions equal to a users results list in search provider.
                        showResults = true;
                        showClearButton = true;
                        showRecents = false;
                        setState(() {});
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              search.recentSearches[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                            // Container makes it so emojis don't render all choppy. Replace it with a button or leave it like so.
                            Container(height: 0.25, color: Colors.transparent),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      search.removeRecentSearch(index: index, authToken: _userProvider.user.access, userId: _userProvider.user.userId);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 30, right: 14.5),
                      height: 50,
                      alignment: Alignment.center,
                      child: const Icon(Icons.clear, size: 17, color: Colors.grey),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _suggestions(BuildContext context) {
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    return Consumer<SearchProvider>(
      builder: (context, search, child) {
        if (search.isSearching) {
          return LayoutBuilder(
            builder: (context, constraints) => ListView(
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: LoadingSpinner(color: darkModeIsOn ? Colors.white : Colors.black),
                ),
              ],
            ),
          );
        }
        return Scrollbar(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: search.searchSuggestions.length,
            padding: EdgeInsets.only(bottom: navBarHeight(context)),
            itemBuilder: (context, index) {
              return ProfilePreviewCard(
                profileId: search.searchSuggestions[index].profileId,
                name: search.searchSuggestions[index].name,
                username: search.searchSuggestions[index].username,
                imageUrl: search.searchSuggestions[index].miniProfilePicture,
                trailingWidget: Container(),
                onTap: () {
                  search.addRecentSearch(query: searchController.text, authToken: _userProvider.user.access, userId: _userProvider.user.userId);
                },
              );
            },
          ),
        );
      },
    );
  }
}
