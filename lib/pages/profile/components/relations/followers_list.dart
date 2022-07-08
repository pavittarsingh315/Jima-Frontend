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
import 'package:nerajima/utils/custom_bottom_sheet.dart';

class FollowersList extends StatefulWidget {
  final String profileId;
  const FollowersList({Key? key, required this.profileId}) : super(key: key);

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final int limit = 10;
  int page = 1;
  bool isLoading = false, hasError = false, hasMore = true;
  List<SearchUser> followersList = [];

  @override
  void initState() {
    super.initState();
    _getFollowers();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        if (!hasError) _getFollowers();
      }
    });
  }

  Future<void> _getFollowers() async {
    try {
      if (isLoading || !hasMore) return; // prevents excess requests being performed.
      isLoading = true;

      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      final url = Uri.parse("${ApiEndpoints.getAProfilesFollowers}/${widget.profileId}?page=$page&limit=$limit");
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
          followersList.addAll(parsedRes);
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
    return Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.95, child: followersBody(context)));
  }

  Widget followersBody(BuildContext context) {
    if (followersList.isEmpty) {
      return nonErrorMessageBody(
        context,
        const Icon(CupertinoIcons.person, size: 50),
        "No Followers",
        "This user currently has no followers. Help them out?",
      );
    }
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: followersList.length + 1,
      padding: EdgeInsets.only(bottom: navBarHeight(context)),
      itemBuilder: (BuildContext context, int index) {
        if (index == followersList.length) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: hasMore ? 25.0 : 0),
            child: hasMore ? Center(child: loadingBody(context)) : const SizedBox(),
          );
        }
        return ProfilePreviewCard(
          profileId: followersList[index].profileId,
          name: followersList[index].name,
          username: followersList[index].username,
          imageUrl: followersList[index].miniProfilePicture,
          trailingWidget: RemoveButton(
            profileId: widget.profileId,
            followerId: followersList[index].profileId,
            followerUsername: followersList[index].username,
          ),
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
            SizedBox(height: size.height / 4),
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

class RemoveButton extends StatefulWidget {
  final String profileId, followerId, followerUsername;
  const RemoveButton({Key? key, required this.profileId, required this.followerId, required this.followerUsername}) : super(key: key);

  @override
  State<RemoveButton> createState() => _RemoveButtonState();
}

class _RemoveButtonState extends State<RemoveButton> {
  bool arePerformingAction = false;
  bool didRemoveFollower = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    // this case is only met when viewing someone else's followers and the current user is in that followers
    if (userProvider.user.profileId == widget.followerId) return _unfollowButton(context);

    // if the profile whose followers we're viewing isn't ours, show nothing
    if (userProvider.user.profileId != widget.profileId) return const SizedBox();

    return PillButton(
      onTap: () async {
        if (arePerformingAction) return; // prevents spam
        bool? confirmRemove = await showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          enableDrag: true,
          useRootNavigator: true,
          builder: (context) {
            return CustomBottomSheet(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.of(context).pop(true),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text("🥾 ${widget.followerUsername} ⁉️", style: const TextStyle(fontSize: 17)),
                  ),
                ),
              ],
            );
          },
        );

        if (confirmRemove ?? false) {
          arePerformingAction = true;
          setState(() {});

          final res = await userProvider.removeFollower(profileId: widget.followerId);
          if (res["status"]) didRemoveFollower = true;

          arePerformingAction = false;
          setState(() {});
        }
      },
      color: Colors.red,
      width: 100,
      enabled: !didRemoveFollower,
      child: arePerformingAction ? const LoadingSpinner() : Text(!didRemoveFollower ? "Remove" : "Removed"),
    );
  }

  bool areFollowing = true;

  Widget _unfollowButton(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    return PillButton(
      onTap: () async {
        if (arePerformingAction) return; // prevents spam
        arePerformingAction = true;
        setState(() {});

        if (areFollowing) {
          final res = await userProvider.unfollowUser(profileId: widget.profileId);
          if (res["status"]) areFollowing = false;
        } else {
          final res = await userProvider.followUser(profileId: widget.profileId);
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
