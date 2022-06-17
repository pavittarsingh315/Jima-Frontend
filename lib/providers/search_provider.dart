import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:nerajima/utils/api_endpoints.dart';
import 'package:nerajima/models/search_models.dart';

class SearchProvider extends ChangeNotifier {
  bool _isSearching = false;
  bool _fetchedRecents = false;
  List<String> _recentSearches = [];
  List<SearchUser> _searchSuggestions = [];

  bool get isSearching => _isSearching;
  List<String> get recentSearches => _recentSearches;
  List<SearchUser> get searchSuggestions => _searchSuggestions;

  Map<String, String> _setHeaders({required String authToken, required String userId}) {
    return {'Content-Type': "application/json", 'Token': authToken, 'UserId': userId};
  }

  Future<void> getRecentSearches({required String authToken, required String userId}) async {
    if (_fetchedRecents) return;

    final url = Uri.parse(ApiEndpoints.getSearchHistory);
    Response response = await get(url, headers: _setHeaders(authToken: authToken, userId: userId));
    final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

    if (resData["message"] == "Success") {
      List<String> recents = resData["data"]["data"].cast<String>();
      _recentSearches = recents;
      _fetchedRecents = true;
    } else if (resData["message"] == "Error") {
      _recentSearches = [];
    }
    notifyListeners();
  }

  Future<void> clearRecentSearches({required String authToken, required String userId}) async {
    if (_recentSearches.isEmpty) return;

    _recentSearches = [];
    notifyListeners();

    final url = Uri.parse(ApiEndpoints.clearSearchHistory);
    await put(url, headers: _setHeaders(authToken: authToken, userId: userId));
  }

  Future<void> addRecentSearch({required String query, required String authToken, required String userId}) async {
    if (_recentSearches.contains(query)) {
      int index = _recentSearches.indexOf(query);
      _recentSearches.removeAt(index);
    }
    List<String> combined = [query] + _recentSearches;
    _recentSearches = combined;
    if (_recentSearches.length > 22) {
      _recentSearches.removeLast();
    }
    notifyListeners();

    final url = Uri.parse("${ApiEndpoints.addToSearchHistory}/$query");
    await put(url, headers: _setHeaders(authToken: authToken, userId: userId));
  }

  Future<void> removeRecentSearch({required int index, required String authToken, required String userId}) async {
    if (_recentSearches.isEmpty) return;

    _recentSearches.removeAt(index);
    notifyListeners();

    final url = Uri.parse("${ApiEndpoints.removeFromSearchHistory}/$index");
    await put(url, headers: _setHeaders(authToken: authToken, userId: userId));
  }

  Future<void> makeSearch({required String query, required String authToken, required String userId}) async {
    if (query != "") {
      _isSearching = true;
      notifyListeners();

      final url = Uri.parse("${ApiEndpoints.searchForUser}/$query");
      Response response = await get(url, headers: _setHeaders(authToken: authToken, userId: userId));
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        List resArray = resData["data"]["data"];
        List<SearchUser> suggestions = resArray.map((e) {
          return SearchUser.fromJson(e);
        }).toList();
        _searchSuggestions = suggestions;
      } else if (resData["message"] == "Error") {
        _searchSuggestions = [];
      }
      _isSearching = false;
      notifyListeners();
    }
  }
}
