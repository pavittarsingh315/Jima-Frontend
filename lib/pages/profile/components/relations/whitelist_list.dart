import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/models/search_models.dart';
import 'package:nerajima/utils/api_endpoints.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/components/profile_preview_card.dart';

class WhitelistList extends StatefulWidget {
  final String profileId;
  const WhitelistList({Key? key, required this.profileId}) : super(key: key);

  @override
  State<WhitelistList> createState() => _WhitelistListState();
}

class _WhitelistListState extends State<WhitelistList> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final int limit = 10;
  int page = 1;
  bool isLoading = false, hasError = false, hasMore = true, accessGranted = false;
  List<SearchUser> whitelistedList = [];

  @override
  void initState() {
    super.initState();
    accessGranted = _checkAccessStatus();
    if (accessGranted) _getWhitelist();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        if (!hasError) _getWhitelist();
      }
    });
  }

  bool _checkAccessStatus() {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if (widget.profileId == userProvider.user.profileId) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _getWhitelist() async {
    try {
      if (isLoading || !hasMore) return; // prevents excess requests being performed.
      isLoading = true;

      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      final url = Uri.parse("${ApiEndpoints.getWhitelist}?page=$page&limit=$limit");
      Response response = await get(url, headers: userProvider.requestHeaders);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        List resArray = resData["data"]["data"];
        List<SearchUser> parsedRes = resArray.map((e) {
          return SearchUser.fromJson(e);
        }).toList();

        setState(() {
          hasMore = parsedRes.length == limit;
          isLoading = false;
          page++;
          whitelistedList.addAll(parsedRes);
        });
      } else if (resData["message"] == "Error") {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (isLoading) {
      return loadingBody(context);
    } else if (hasError) {
      return errorBody(context);
    } else if (!accessGranted) {
      return nonErrorMessageBody(
        context,
        const Icon(CupertinoIcons.nosign, size: 50, color: Colors.red),
        "Access Denied",
        "You are only allowed to view your own whitelist.",
      );
    }
    return Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.95, child: whitelistBody(context)));
  }

  Widget whitelistBody(BuildContext context) {
    if (whitelistedList.isEmpty) {
      return nonErrorMessageBody(
        context,
        const Icon(CupertinoIcons.person, size: 50),
        "Empty Whitelist",
        "You currently have no one whitelisted to view your private posts.",
      );
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: whitelistedList.length + 1,
      padding: EdgeInsets.only(bottom: navBarHeight(context)),
      itemBuilder: (BuildContext context, int index) {
        if (index == whitelistedList.length) {
          return Container(
            padding: EdgeInsets.only(top: hasMore ? 25.0 : 0),
            child: hasMore ? Center(child: loadingBody(context)) : const SizedBox(),
          );
        }
        return ProfilePreviewCard(
          profileId: whitelistedList[index].profileId,
          name: whitelistedList[index].name,
          username: whitelistedList[index].username,
          imageUrl: whitelistedList[index].miniProfilePicture,
        );
      },
    );
  }

  Widget loadingBody(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: LoadingSpinner(color: theme.isDarkModeEnabled ? Colors.white : Colors.black),
        );
      },
    );
  }

  Widget errorBody(BuildContext context) {
    return const Center(child: Text("Error..."));
  }

  Widget nonErrorMessageBody(BuildContext context, Icon icon, String title, String description) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: size.height / 3.33),
        icon,
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 35),
        ),
        const SizedBox(height: 10),
        Text(description),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
