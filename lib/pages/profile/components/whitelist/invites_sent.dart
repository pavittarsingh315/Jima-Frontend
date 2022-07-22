import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/whitelist_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/components/profile_preview_card.dart';
import 'package:nerajima/components/pill_button.dart';
import 'package:nerajima/utils/custom_bottom_sheet.dart';

class InvitesSent extends StatefulWidget {
  const InvitesSent({Key? key}) : super(key: key);

  @override
  State<InvitesSent> createState() => _InvitesSentState();
}

class _InvitesSentState extends State<InvitesSent> with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      WhitelistProvider whitelistProvider = Provider.of<WhitelistProvider>(context, listen: false);

      // so that when we reopen this page, no new request is made until user scrolls to bottom
      if (whitelistProvider.sentInvPage == 1) {
        await whitelistProvider.getSentInvites(headers: userProvider.requestHeaders);
      }
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.offset) {
          await whitelistProvider.getSentInvites(headers: userProvider.requestHeaders);
        }
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<WhitelistProvider>(
      builder: (context, whitelist, child) {
        if (whitelist.isSentInvLoading) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: loadingBody(context),
          );
        } else if (whitelist.sentInvHasError) {
          return errorBody(context);
        } else {
          return Scaffold(
            body: Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.95, child: sentBody(context, whitelist))),
          );
        }
      },
    );
  }

  Widget sentBody(BuildContext context, WhitelistProvider whitelist) {
    if (whitelist.sentInvites.isEmpty) return emptyBody(context);

    return Scrollbar(
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: whitelist.sentInvites.length + 1,
        padding: EdgeInsets.only(bottom: navBarHeight(context)),
        itemBuilder: (context, index) {
          if (index == whitelist.sentInvites.length) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: whitelist.sentInvHasMore ? 25.0 : 0),
              child: whitelist.sentInvHasMore ? Center(child: loadingBody(context)) : const SizedBox(),
            );
          }
          return ProfilePreviewCard(
            profileId: whitelist.sentInvites[index].receiverProfile!.profileId,
            name: whitelist.sentInvites[index].receiverProfile!.name,
            username: whitelist.sentInvites[index].receiverProfile!.username,
            imageUrl: whitelist.sentInvites[index].receiverProfile!.miniProfilePicture,
            trailingWidget: SentInvitesAction(
              index: index,
              inviteId: whitelist.sentInvites[index].invitationId,
              profileId: whitelist.sentInvites[index].receiverProfile!.profileId,
              didInviteUser: whitelist.sentInvites[index].didInviteUser,
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

  Widget emptyBody(BuildContext context) {
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
                children: const [
                  Icon(CupertinoIcons.paperplane, size: 50),
                  SizedBox(height: 10),
                  Text(
                    "No Invites",
                    style: TextStyle(fontSize: 35),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text("You currently have no invites that are pending.", textAlign: TextAlign.center),
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

class SentInvitesAction extends StatefulWidget {
  final int index;
  final String inviteId, profileId;
  final bool didInviteUser;
  const SentInvitesAction({
    Key? key,
    required this.index,
    required this.inviteId,
    required this.profileId,
    required this.didInviteUser,
  }) : super(key: key);

  @override
  State<SentInvitesAction> createState() => _SentInvitesActionState();
}

class _SentInvitesActionState extends State<SentInvitesAction> {
  late bool didInviteUser = widget.didInviteUser;
  bool arePerformingAction = false;

  @override
  Widget build(BuildContext context) {
    if (didInviteUser) {
      return _cancelButton(context);
    } else {
      return PillButton(onTap: () {}, color: primary, enabled: false, width: 100, child: const Text("Canceled"));
    }
  }

  Widget _cancelButton(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    WhitelistProvider whitelistProvider = Provider.of<WhitelistProvider>(context, listen: false);
    return PillButton(
      onTap: () async {
        if (arePerformingAction) return; // prevents spam
        bool? confirmCancel = await showModalBottomSheet(
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
                    child: const Text("Cancel Invite", style: TextStyle(fontSize: 17, color: Colors.red)),
                  ),
                ),
              ],
            );
          },
        );

        if (confirmCancel ?? false) {
          setState(() => arePerformingAction = true);

          final res = await whitelistProvider.cancelWhitelistInvite(inviteId: widget.inviteId, headers: userProvider.requestHeaders);
          if (res['status']) {
            didInviteUser = false;
            whitelistProvider.sentInvites[widget.index].didInviteUser = false;
          }

          setState(() => arePerformingAction = false);
        }
      },
      color: Colors.red,
      width: 100,
      child: arePerformingAction ? const LoadingSpinner() : const Text("Cancel"),
    );
  }
}
