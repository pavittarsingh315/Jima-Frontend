import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/whitelist_provider.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/pages/profile/components/relations/whitelist_button.dart';
import 'package:nerajima/components/pill_button.dart';
import 'package:nerajima/components/profile_preview_card.dart';
import 'package:nerajima/utils/custom_bottom_sheet.dart';

class WhitelistList extends StatefulWidget {
  final String profileId;
  const WhitelistList({Key? key, required this.profileId}) : super(key: key);

  @override
  State<WhitelistList> createState() => _WhitelistListState();
}

class _WhitelistListState extends State<WhitelistList> with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();
  bool accessGranted = false;

  @override
  void initState() {
    super.initState();
    accessGranted = _checkAccessStatus();
    Future.delayed(Duration.zero, () async {
      if (accessGranted) {
        UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
        WhitelistProvider whitelistProvider = Provider.of<WhitelistProvider>(context, listen: false);

        // so that when we reopen this page, no new request is made until user scrolls to bottom
        if (whitelistProvider.listPage == 1) {
          await whitelistProvider.getWhitelist(authToken: userProvider.user.access, userId: userProvider.user.userId, headers: userProvider.requestHeaders);
        }
        scrollController.addListener(() async {
          if (scrollController.position.maxScrollExtent == scrollController.offset) {
            await whitelistProvider.getWhitelist(authToken: userProvider.user.access, userId: userProvider.user.userId, headers: userProvider.requestHeaders);
          }
        });
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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!accessGranted) {
      return nonErrorMessageBody(
        context,
        const Icon(CupertinoIcons.nosign, size: 50, color: Colors.red),
        "Access Denied",
        "You are only allowed to view your own whitelist.",
      );
    } else {
      return Consumer<WhitelistProvider>(
        builder: (context, whitelist, child) {
          if (whitelist.isListLoading) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: loadingBody(context),
            );
          } else if (whitelist.listHasError) {
            return errorBody(context);
          } else {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.95, child: whitelistBody(context, whitelist))),
              floatingActionButton: const Padding(padding: EdgeInsets.only(bottom: 50), child: WhitelistButton()),
            );
          }
        },
      );
    }
  }

  Widget whitelistBody(BuildContext context, WhitelistProvider whitelist) {
    if (whitelist.whitelistedList.isEmpty) {
      return nonErrorMessageBody(
        context,
        const Icon(CupertinoIcons.person, size: 50),
        "Empty Whitelist",
        "You currently have no one whitelisted to view your private posts.",
      );
    }
    return Scrollbar(
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: whitelist.whitelistedList.length + 1,
        padding: EdgeInsets.only(bottom: navBarHeight(context)),
        itemBuilder: (BuildContext context, int index) {
          if (index == whitelist.whitelistedList.length) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: whitelist.listHasMore ? 25.0 : 0),
              child: whitelist.listHasMore ? Center(child: loadingBody(context)) : const SizedBox(),
            );
          }
          return ProfilePreviewCard(
            profileId: whitelist.whitelistedList[index].profileId,
            name: whitelist.whitelistedList[index].name,
            username: whitelist.whitelistedList[index].username,
            imageUrl: whitelist.whitelistedList[index].miniProfilePicture,
            trailingWidget: WhitelistActionButton(
              whitelistedUserId: whitelist.whitelistedList[index].profileId,
              whitelistedUsername: whitelist.whitelistedList[index].username,
            ),
          );
        },
      ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: constraints.maxHeight - navBarHeight(context)),
              alignment: Alignment.center,
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
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
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class WhitelistActionButton extends StatefulWidget {
  final String whitelistedUserId, whitelistedUsername;
  const WhitelistActionButton({Key? key, required this.whitelistedUserId, required this.whitelistedUsername}) : super(key: key);

  @override
  State<WhitelistActionButton> createState() => _WhitelistActionButtonState();
}

class _WhitelistActionButtonState extends State<WhitelistActionButton> {
  bool arePerformingAction = false;
  bool didBlacklistUser = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if (didBlacklistUser) {
      return _inviteButton(context, userProvider);
    } else {
      return _removeButton(context, userProvider);
    }
  }

  bool didInviteUser = false;
  Widget _inviteButton(BuildContext context, UserProvider userProvider) {
    return PillButton(
      onTap: () async {
        if (arePerformingAction) return;
        setState(() => arePerformingAction = true);

        final res = await userProvider.inviteToWhitelist(profileId: widget.whitelistedUserId);
        if (res["status"]) didInviteUser = true;

        setState(() => arePerformingAction = false);
      },
      color: primary,
      width: 100,
      enabled: !didInviteUser,
      child: arePerformingAction ? const LoadingSpinner() : Text(!didInviteUser ? "Invite" : "Invited"),
    );
  }

  Widget _removeButton(BuildContext context, UserProvider userProvider) {
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
                    child: Text("Remove ${widget.whitelistedUsername}", style: const TextStyle(fontSize: 17, color: Colors.red)),
                  ),
                ),
              ],
            );
          },
        );

        if (confirmRemove ?? false) {
          arePerformingAction = true;
          setState(() {});

          final res = await userProvider.blacklistUser(profileId: widget.whitelistedUserId);
          if (res["status"]) didBlacklistUser = true;

          arePerformingAction = false;
          setState(() {});
        }
      },
      color: Colors.red,
      width: 100,
      child: arePerformingAction ? const LoadingSpinner() : const Text("Remove"),
    );
  }
}
