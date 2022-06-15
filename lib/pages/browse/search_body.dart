import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/search_provider.dart';
import 'package:nerajima/pages/browse/search_bar.dart';
import 'package:nerajima/pages/browse/search_results.dart';

// TODO: show clear button in search bar when clicking a recent
class SearchBody extends StatefulWidget {
  const SearchBody({Key? key}) : super(key: key);

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
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
        SearchBar(
          setShowRecents: setShowRecents,
          setShowResults: setShowResults,
          searchController: searchController,
          onEditingComplete: () {
            _searchProvider.addRecentSearch(query: searchController.text, authToken: _userProvider.user.access, userId: _userProvider.user.userId);
          },
        ),
        if (showRecents) _clearRecentSearches(context),
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

  Widget _clearRecentSearches(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, search, child) {
        if (search.recentSearches.isEmpty) {
          return const SizedBox();
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Search History",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 15),
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    search.clearRecentSearches(authToken: _userProvider.user.access, userId: _userProvider.user.userId);
                  },
                  style: ButtonStyle(overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Colors.transparent)),
                  child: const Text(
                    "Clear",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            ),
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
            return ListTile(
              title: Text(search.recentSearches[index]),
              trailing: IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  search.removeRecentSearch(index: index, authToken: _userProvider.user.access, userId: _userProvider.user.userId);
                },
                icon: const Icon(Icons.clear, size: 17),
              ),
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                searchController.text = search.recentSearches[index];
                search.addRecentSearch(query: searchController.text, authToken: _userProvider.user.access, userId: _userProvider.user.userId);
                showResults = true;
                setState(() {});
              },
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
