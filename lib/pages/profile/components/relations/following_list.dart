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
import 'package:nerajima/components/pill_button.dart';

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
  List<SearchUser> followingList = [];

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
      final url = Uri.parse("${ApiEndpoints.getAProfilesFollowing}/${widget.profileId}?page=$page&limit=$limit");
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
      return Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: loadingBody(context),
      );
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
            padding: EdgeInsets.symmetric(vertical: hasMore ? 25.0 : 0),
            child: hasMore ? Center(child: loadingBody(context)) : const SizedBox(),
          );
        }
        return ProfilePreviewCard(
          profileId: followingList[index].profileId,
          name: followingList[index].name,
          username: followingList[index].username,
          imageUrl: followingList[index].miniProfilePicture,
          trailingWidget: UnfollowButton(followingId: followingList[index].profileId),
        );
      },
    );
  }

  Widget loadingBody(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) {
        return LoadingSpinner(color: theme.isDarkModeEnabled ? Colors.white : Colors.black);
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

class UnfollowButton extends StatefulWidget {
  final String followingId;
  const UnfollowButton({Key? key, required this.followingId}) : super(key: key);

  @override
  State<UnfollowButton> createState() => _UnfollowButtonState();
}

class _UnfollowButtonState extends State<UnfollowButton> {
  bool arePerformingAction = false;
  bool areFollowing = true;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    return PillButton(
      onTap: () async {
        if (arePerformingAction) return; // prevents spam
        arePerformingAction = true;
        setState(() {});

        if (areFollowing) {
          final res = await userProvider.unfollowUser(profileId: widget.followingId);
          if (res["status"]) areFollowing = false;
        } else {
          final res = await userProvider.followUser(profileId: widget.followingId);
          if (res["status"]) areFollowing = true;
        }

        arePerformingAction = false;
        setState(() {});
      },
      color: areFollowing ? Colors.red : primary,
      width: 100,
      child: arePerformingAction ? const LoadingSpinner() : Text(areFollowing ? "Unfollow" : "Follow"),
    );
  }
}
