import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:nerajima/utils/api_endpoints.dart';
import 'package:nerajima/models/search_models.dart';

class WhitelistProvider extends ChangeNotifier {
  final int _limit = 30;

  int _listPage = 1;
  bool _isListLoading = false, _listHasError = false, _listHasMore = true;
  List<SearchUser> whitelistedList = [];

  bool get isListLoading => _isListLoading;
  bool get listHasError => _listHasError;
  bool get listHasMore => _listHasMore;
  int get listPage => _listPage;

  Future<void> getWhitelist({required String authToken, required String userId, required Map<String, String> headers}) async {
    try {
      if (_listHasError) return;

      if (_isListLoading || !_listHasMore) return; // prevents excess requests being performed.
      _isListLoading = true;
      if (_listPage == 1) notifyListeners(); // this is so that a spinner is only shown in whitelist_list page when the page is first accessed

      final url = Uri.parse("${ApiEndpoints.getWhitelist}?page=$_listPage&limit=$_limit");
      Response response = await get(url, headers: headers);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        List resArray = resData["data"]["data"];
        List<SearchUser> parsedRes = resArray.map((e) {
          return SearchUser.fromJson(e);
        }).toList();

        _listHasMore = parsedRes.length == _limit;
        _isListLoading = false;
        _listPage++;
        whitelistedList.addAll(parsedRes);
        notifyListeners();
        return;
      } else if (resData["message"] == "Error") {
        _isListLoading = false;
        _listHasError = true;
        notifyListeners();
        return;
      }

      throw Exception("Failed to load whitelist...");
    } catch (e) {
      _isListLoading = false;
      _listHasError = true;
      notifyListeners();
      return Future.error(e);
    }
  }

  int _sentInvPage = 1;
  bool _isSentInvLoading = false, _sentInvHasError = false, _sentInvHasMore = true;

  int get sentInvPage => _sentInvPage;
  bool get isSentInvLoading => _isSentInvLoading;
  bool get sentInvHasError => _sentInvHasError;
  bool get sentInvHasMore => _sentInvHasMore;

  Future<void> getSentInvites({required String authToken, required String userId, required Map<String, String> headers}) async {
    try {
      if (_sentInvHasError) return;
      if (_isSentInvLoading || !_sentInvHasMore) return;
      _isSentInvLoading = true;
      if (_sentInvPage == 1) notifyListeners();

      final url = Uri.parse("${ApiEndpoints.getSentWhitelistInvites}?page=$_sentInvPage&limit=$_limit");
      Response response = await get(url, headers: headers);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        List resArray = resData["data"]["data"];
        print(resArray);

        return;
      } else if (resData["message"] == "Error") {
        _isSentInvLoading = false;
        _sentInvHasError = true;
        notifyListeners();
        return;
      }

      throw Exception("Failed to load sent invites...");
    } catch (e) {
      _isSentInvLoading = false;
      _sentInvHasError = true;
      notifyListeners();
      return Future.error(e);
    }
  }

  int _receivedInvPage = 1;
  bool _isReceivedInvLoading = false, _receivedInvHasError = false, _receivedInvHasMore = true;

  int get receivedInvPage => _receivedInvPage;
  bool get isReceivedInvLoading => _isReceivedInvLoading;
  bool get receivedInvHasError => _receivedInvHasError;
  bool get receivedInvHasMore => _receivedInvHasMore;

  Future<void> getReceivedInvites({required String authToken, required String userId, required Map<String, String> headers}) async {
    try {
      if (_receivedInvHasError) return;
      if (_isReceivedInvLoading || !_receivedInvHasMore) return;
      _isReceivedInvLoading = true;
      if (_receivedInvPage == 1) notifyListeners();

      final url = Uri.parse("${ApiEndpoints.getReceivedWhitelistInvites}?page=$_receivedInvPage&limit=$_limit");
      Response response = await get(url, headers: headers);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        List resArray = resData["data"]["data"];
        print(resArray);

        return;
      } else if (resData["message"] == "Error") {
        _isReceivedInvLoading = false;
        _receivedInvHasError = true;
        notifyListeners();
        return;
      }

      throw Exception("Failed to load received invites...");
    } catch (e) {
      _isReceivedInvLoading = false;
      _receivedInvHasError = true;
      notifyListeners();
      return Future.error(e);
    }
  }

  int _sentReqPage = 1;
  bool _isSentReqLoading = false, _sentReqHasError = false, _sentReqHasMore = true;

  int get sentReqPage => _sentReqPage;
  bool get isSentReqLoading => _isSentReqLoading;
  bool get sentReqHasError => _sentReqHasError;
  bool get sentReqHasMore => _sentReqHasMore;

  Future<void> getSentRequests({required String authToken, required String userId, required Map<String, String> headers}) async {
    try {
      if (_sentReqHasError) return;
      if (_isSentReqLoading || !_sentReqHasMore) return;
      _isSentReqLoading = true;
      if (_sentReqPage == 1) notifyListeners();

      final url = Uri.parse("${ApiEndpoints.getSentWhitelistRequests}?page=$_sentReqPage&limit=$_limit");
      Response response = await get(url, headers: headers);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        List resArray = resData["data"]["data"];
        print(resArray);

        return;
      } else if (resData["message"] == "Error") {
        _isSentReqLoading = false;
        _sentReqHasError = true;
        notifyListeners();
        return;
      }

      throw Exception("Failed to load sent requests...");
    } catch (e) {
      _isSentReqLoading = false;
      _sentReqHasError = true;
      notifyListeners();
      return Future.error(e);
    }
  }

  int _receivedReqPage = 1;
  bool _isReceivedReqLoading = false, _receivedReqHasError = false, _receivedReqHasMore = true;

  int get receivedReqPage => _receivedReqPage;
  bool get isReceivedReqLoading => _isReceivedReqLoading;
  bool get receivedReqHasError => _receivedReqHasError;
  bool get receivedReqHasMore => _receivedReqHasMore;

  Future<void> getReceivedRequests({required String authToken, required String userId, required Map<String, String> headers}) async {
    try {
      if (_receivedReqHasError) return;
      if (_isReceivedReqLoading || !_receivedReqHasMore) return;
      _isReceivedReqLoading = true;
      if (_receivedReqPage == 1) notifyListeners();

      final url = Uri.parse("${ApiEndpoints.getReceivedWhitelistRequests}?page=$_receivedReqPage&limit=$_limit");
      Response response = await get(url, headers: headers);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        List resArray = resData["data"]["data"];
        print(resArray);

        return;
      } else if (resData["message"] == "Error") {
        _isReceivedReqLoading = false;
        _receivedReqHasError = true;
        notifyListeners();
        return;
      }

      throw Exception("Failed to load received requests...");
    } catch (e) {
      _isReceivedReqLoading = false;
      _receivedReqHasError = true;
      notifyListeners();
      return Future.error(e);
    }
  }
}
