import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:nerajima/utils/api_endpoints.dart';

class SearchProvider extends ChangeNotifier {
  bool _fetchedRecents = false;
  List<String> recentSearches = [];

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
      recentSearches = recents;
      _fetchedRecents = true;
    } else if (resData["message"] == "Error") {
      recentSearches = [];
    }
    notifyListeners();
  }

  Future<void> clearRecentSearches({required String authToken, required String userId}) async {
    if (recentSearches.isEmpty) return;

    recentSearches = [];
    notifyListeners();

    final url = Uri.parse(ApiEndpoints.clearSearchHistory);
    await put(url, headers: _setHeaders(authToken: authToken, userId: userId));
  }

  Future<void> addRecentSearch({required String query, required String authToken, required String userId}) async {
    if (recentSearches.contains(query)) {
      int index = recentSearches.indexOf(query);
      recentSearches.removeAt(index);
    }
    List<String> combined = [query] + recentSearches;
    recentSearches = combined;
    if (recentSearches.length > 22) {
      recentSearches.removeLast();
    }
    notifyListeners();

    final url = Uri.parse("${ApiEndpoints.addToSearchHistory}/$query");
    await put(url, headers: _setHeaders(authToken: authToken, userId: userId));
  }

  Future<void> removeRecentSearch({required int index, required String authToken, required String userId}) async {
    if (recentSearches.isEmpty) return;

    recentSearches.removeAt(index);
    notifyListeners();

    final url = Uri.parse("${ApiEndpoints.removeFromSearchHistory}/$index");
    await put(url, headers: _setHeaders(authToken: authToken, userId: userId));
  }
}
