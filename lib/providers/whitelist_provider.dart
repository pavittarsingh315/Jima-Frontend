import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:nerajima/utils/api_endpoints.dart';
import 'package:nerajima/models/search_models.dart';
import 'package:nerajima/models/whitelist_model.dart';

class WhitelistProvider extends ChangeNotifier {
  final int _limit = 30;

  int _listPage = 1;
  bool _isListLoading = false, _listHasError = false, _listHasMore = true;
  List<SearchUser> whitelistedList = [];

  bool get isListLoading => _isListLoading;
  bool get listHasError => _listHasError;
  bool get listHasMore => _listHasMore;
  int get listPage => _listPage;

  Future<void> getWhitelist({required Map<String, String> headers}) async {
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
  List<WhitelistInvitation> sentInvites = [];

  int get sentInvPage => _sentInvPage;
  bool get isSentInvLoading => _isSentInvLoading;
  bool get sentInvHasError => _sentInvHasError;
  bool get sentInvHasMore => _sentInvHasMore;

  Future<void> getSentInvites({required Map<String, String> headers}) async {
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
        List<WhitelistInvitation> parsedRes = resArray.map((e) {
          return WhitelistInvitation.fromJson(e);
        }).toList();

        _sentInvHasMore = parsedRes.length == _limit;
        _isSentInvLoading = false;
        _sentInvPage++;
        sentInvites.addAll(parsedRes);
        notifyListeners();
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
  List<WhitelistInvitation> receivedInvites = [];

  int get receivedInvPage => _receivedInvPage;
  bool get isReceivedInvLoading => _isReceivedInvLoading;
  bool get receivedInvHasError => _receivedInvHasError;
  bool get receivedInvHasMore => _receivedInvHasMore;

  Future<void> getReceivedInvites({required Map<String, String> headers}) async {
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
        List<WhitelistInvitation> parsedRes = resArray.map((e) {
          return WhitelistInvitation.fromJson(e);
        }).toList();

        _receivedInvHasMore = parsedRes.length == _limit;
        _isReceivedInvLoading = false;
        _receivedInvPage++;
        receivedInvites.addAll(parsedRes);
        notifyListeners();
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
  List<WhitelistRequest> sentRequests = [];

  int get sentReqPage => _sentReqPage;
  bool get isSentReqLoading => _isSentReqLoading;
  bool get sentReqHasError => _sentReqHasError;
  bool get sentReqHasMore => _sentReqHasMore;

  Future<void> getSentRequests({required Map<String, String> headers}) async {
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
        List<WhitelistRequest> parsedRes = resArray.map((e) {
          return WhitelistRequest.fromJson(e);
        }).toList();

        _sentReqHasMore = parsedRes.length == _limit;
        _isSentReqLoading = false;
        _sentReqPage++;
        sentRequests.addAll(parsedRes);
        notifyListeners();
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
  List<WhitelistRequest> receivedRequests = [];

  int get receivedReqPage => _receivedReqPage;
  bool get isReceivedReqLoading => _isReceivedReqLoading;
  bool get receivedReqHasError => _receivedReqHasError;
  bool get receivedReqHasMore => _receivedReqHasMore;

  Future<void> getReceivedRequests({required Map<String, String> headers}) async {
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
        List<WhitelistRequest> parsedRes = resArray.map((e) {
          return WhitelistRequest.fromJson(e);
        }).toList();

        _receivedReqHasMore = parsedRes.length == _limit;
        _isReceivedReqLoading = false;
        _receivedReqPage++;
        receivedRequests.addAll(parsedRes);
        notifyListeners();
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

  /// Success map keys: [status]. Error map keys: [status, message].
  Future<Map<String, dynamic>> cancelWhitelistInvite({required String inviteId, required Map<String, String> headers}) async {
    try {
      final url = Uri.parse("${ApiEndpoints.revokeWhitelistInvite}/$inviteId");
      Response response = await delete(url, headers: headers);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong canceling the invite...");
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Success map keys: [status]. Error map keys: [status, message].
  Future<Map<String, dynamic>> acceptWhitelistInvite({required String inviteId, required Map<String, String> headers}) async {
    try {
      final url = Uri.parse("${ApiEndpoints.acceptWhitelistInvite}/$inviteId");
      Response response = await post(url, headers: headers);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong accepting the invite...");
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Success map keys: [status]. Error map keys: [status, message].
  Future<Map<String, dynamic>> declineWhitelistInvite({required String inviteId, required Map<String, String> headers}) async {
    try {
      final url = Uri.parse("${ApiEndpoints.declineWhitelistInvite}/$inviteId");
      Response response = await delete(url, headers: headers);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong declining the invite...");
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Success map keys: [status]. Error map keys: [status, message].
  Future<Map<String, dynamic>> cancelWhitelistRequest({required String requestId, required Map<String, String> headers}) async {
    try {
      final url = Uri.parse("${ApiEndpoints.cancelWhitelistEntryRequest}/$requestId");
      Response response = await delete(url, headers: headers);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong canceling the request...");
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Success map keys: [status]. Error map keys: [status, message].
  Future<Map<String, dynamic>> acceptWhitelistRequest({required String requestId, required Map<String, String> headers}) async {
    try {
      final url = Uri.parse("${ApiEndpoints.acceptWhitelistEntryRequest}/$requestId");
      Response response = await post(url, headers: headers);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong accepting the request...");
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Success map keys: [status]. Error map keys: [status, message].
  Future<Map<String, dynamic>> declineWhitelistRequest({required String requestId, required Map<String, String> headers}) async {
    try {
      final url = Uri.parse("${ApiEndpoints.declineWhitelistEntryRequest}/$requestId");
      Response response = await delete(url, headers: headers);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        return {"status": true};
      } else if (resData["message"] == "Error") {
        return {"status": false, "message": resData["data"]["data"]};
      }

      throw Exception("Something went wrong declining the request...");
    } catch (e) {
      return Future.error(e);
    }
  }

  void resetProvider() {
    _listPage = 1;
    _isListLoading = false;
    _listHasError = false;
    _listHasMore = true;
    whitelistedList = [];

    _sentInvPage = 1;
    _isSentInvLoading = false;
    _sentInvHasError = false;
    _sentInvHasMore = true;
    sentInvites = [];

    _receivedInvPage = 1;
    _isReceivedInvLoading = false;
    _receivedInvHasError = false;
    _receivedInvHasMore = true;
    receivedInvites = [];

    _sentReqPage = 1;
    _isSentReqLoading = false;
    _sentReqHasError = false;
    _sentReqHasMore = true;
    sentRequests = [];

    _receivedReqPage = 1;
    _isReceivedReqLoading = false;
    _receivedReqHasError = false;
    _receivedReqHasMore = true;
    receivedRequests = [];
  }
}
