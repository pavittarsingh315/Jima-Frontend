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

class MockData {
  late final int price;
  late final String name;

  MockData({required this.price, required this.name});

  factory MockData.fromJson(Map<String, dynamic> json) {
    return MockData(
      price: json['price'],
      name: json['name'],
    );
  }
}

class FollowingList extends StatefulWidget {
  final String profileId;
  const FollowingList({Key? key, required this.profileId}) : super(key: key);

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final int limit = 15;
  int page = 1;
  bool isLoading = false, hasError = false, hasMore = true;
  List<MockData> followingList = [];

  @override
  void initState() {
    super.initState();
    _getFollowing();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        if (!hasError) _getFollowing();
      }
    });
  }

  Future<void> _getFollowing() async {
    try {
      if (isLoading || !hasMore) return; // prevents excess requests being performed.
      isLoading = true;

      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      final url = Uri.parse("https://testing-jima.herokuapp.com/api/dev/getMockData?page=$page&limit=$limit");
      Response response = await get(url, headers: userProvider.requestHeaders);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        List resArray = resData["data"]["data"];
        List<MockData> parsedRes = resArray.map((e) {
          return MockData.fromJson(e);
        }).toList();

        setState(() {
          hasMore = parsedRes.length == limit;
          isLoading = false;
          page++;
          followingList.addAll(parsedRes);
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
    }
    return Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.95, child: followingBody(context)));
  }

  Widget followingBody(BuildContext context) {
    if (followingList.isEmpty) {
      return nonErrorMessageBody(
        context,
        const Icon(CupertinoIcons.person, size: 50),
        "No Followings",
        "This user currently isn't following anyone.",
      );
    }
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: followingList.length + 1,
      padding: EdgeInsets.only(bottom: navBarHeight(context)),
      itemBuilder: (BuildContext context, int index) {
        if (index == followingList.length) {
          return Container(
            padding: EdgeInsets.only(top: hasMore ? 25.0 : 0),
            child: hasMore ? Center(child: loadingBody(context)) : const SizedBox(),
          );
        }
        return Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: index % 2 == 0 ? Colors.blue.shade100 : Colors.pink.shade100,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(followingList[index].name),
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
    return ListView(
      children: [
        Column(
          children: [
            SizedBox(height: size.height / 3.33),
            icon,
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 35),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(description, textAlign: TextAlign.center),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
