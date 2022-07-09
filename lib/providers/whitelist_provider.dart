import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:nerajima/utils/api_endpoints.dart';
import 'package:nerajima/models/search_models.dart';

class WhitelistProvider extends ChangeNotifier {
  final int _limit = 15;
  int _page = 1;
  bool _isLoading = false, _hasError = false, _hasMore = true;
  List<SearchUser> whitelistedList = [];

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get hasMore => _hasMore;
  int get page => _page;

  Future<void> getWhitelist({required String authToken, required String userId, required Map<String, String> headers}) async {
    try {
      if (_hasError) return;

      if (_isLoading || !_hasMore) return; // prevents excess requests being performed.
      _isLoading = true;
      if (_page == 1) notifyListeners(); // _isLoading only should show during inital load

      final url = Uri.parse("${ApiEndpoints.getWhitelist}?page=$_page&limit=$_limit");
      Response response = await get(url, headers: headers);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        List resArray = resData["data"]["data"];
        List<SearchUser> parsedRes = resArray.map((e) {
          return SearchUser.fromJson(e);
        }).toList();

        _hasMore = parsedRes.length == _limit;
        _isLoading = false;
        _page++;
        whitelistedList.addAll(parsedRes);
        notifyListeners();
        return;
      } else if (resData["message"] == "Error") {
        _isLoading = false;
        _hasError = true;
        notifyListeners();
        return;
      }

      throw Exception("Failed to load whitelist...");
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      notifyListeners();
      return Future.error(e);
    }
  }
}
