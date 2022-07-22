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

class InvitesReceived extends StatefulWidget {
  const InvitesReceived({Key? key}) : super(key: key);

  @override
  State<InvitesReceived> createState() => _InvitesReceivedState();
}

class _InvitesReceivedState extends State<InvitesReceived> with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      WhitelistProvider whitelistProvider = Provider.of<WhitelistProvider>(context, listen: false);

      // so that when we reopen this page, no new request is made until user scrolls to bottom
      if (whitelistProvider.receivedInvPage == 1) {
        await whitelistProvider.getReceivedInvites(headers: userProvider.requestHeaders);
      }
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.offset) {
          await whitelistProvider.getReceivedInvites(headers: userProvider.requestHeaders);
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
        if (whitelist.isReceivedInvLoading) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: loadingBody(context),
          );
        } else if (whitelist.receivedInvHasError) {
          return errorBody(context);
        } else {
          return Scaffold(
            body: Center(child: SizedBox(width: MediaQuery.of(context).size.width * 0.95, child: receivedBody(context, whitelist))),
          );
        }
      },
    );
  }

  Widget receivedBody(BuildContext context, WhitelistProvider whitelist) {
    if (whitelist.receivedInvites.isEmpty) return emptyBody(context);

    return Scrollbar(
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: whitelist.receivedInvites.length + 1,
        padding: EdgeInsets.only(bottom: navBarHeight(context)),
        itemBuilder: (context, index) {
          if (index == whitelist.receivedInvites.length) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: whitelist.receivedInvHasMore ? 25.0 : 0),
              child: whitelist.receivedInvHasMore ? Center(child: loadingBody(context)) : const SizedBox(),
            );
          }
          return ProfilePreviewCard(
            profileId: whitelist.receivedInvites[index].senderProfile!.profileId,
            name: whitelist.receivedInvites[index].senderProfile!.name,
            username: whitelist.receivedInvites[index].senderProfile!.username,
            imageUrl: whitelist.receivedInvites[index].senderProfile!.miniProfilePicture,
            trailingWidget: ReceivedInvitesAction(
              index: index,
              inviteId: whitelist.receivedInvites[index].invitationId,
              profileId: whitelist.receivedInvites[index].senderProfile!.profileId,
              didAccept: whitelist.receivedInvites[index].didAccept,
              didDecline: whitelist.receivedInvites[index].didDecline,
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
                  Icon(CupertinoIcons.mail, size: 50),
                  SizedBox(height: 10),
                  Text(
                    "No Invites",
                    style: TextStyle(fontSize: 35),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text("You currently have no new invites.", textAlign: TextAlign.center),
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

class ReceivedInvitesAction extends StatefulWidget {
  final int index;
  final String inviteId, profileId;
  final bool didAccept, didDecline;
  const ReceivedInvitesAction({
    Key? key,
    required this.index,
    required this.inviteId,
    required this.profileId,
    required this.didAccept,
    required this.didDecline,
  }) : super(key: key);

  @override
  State<ReceivedInvitesAction> createState() => _ReceivedInvitesActionState();
}

class _ReceivedInvitesActionState extends State<ReceivedInvitesAction> {
  late bool didAccept = widget.didAccept, didDecline = widget.didDecline;
  bool arePerformingAction = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    WhitelistProvider whitelistProvider = Provider.of<WhitelistProvider>(context, listen: false);
    if (didAccept) {
      return PillButton(onTap: () {}, color: primary, enabled: false, width: 100, child: const Text("Accepted"));
    } else if (didDecline) {
      return PillButton(onTap: () {}, color: primary, enabled: false, width: 100, child: const Text("Declined"));
    } else {
      return Row(children: [_acceptButton(context, whitelistProvider, userProvider), const SizedBox(width: 5), _declineButton(context, whitelistProvider, userProvider)]);
    }
  }

  Future<bool?> showConfirmModal({required String message}) async {
    bool? value = await showModalBottomSheet(
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
                child: Text(message, style: const TextStyle(fontSize: 17, color: Colors.red)),
              ),
            ),
          ],
        );
      },
    );

    return value;
  }

  Widget _acceptButton(BuildContext context, WhitelistProvider whitelistProvider, UserProvider userProvider) {
    return PillButton(
      onTap: () async {
        if (arePerformingAction) return; // prevents spam
        bool? confirmAccept = await showConfirmModal(message: "Accept Invite");

        if (confirmAccept ?? false) {
          setState(() => arePerformingAction = true);

          final res = await whitelistProvider.acceptWhitelistInvite(inviteId: widget.inviteId, headers: userProvider.requestHeaders);
          if (res['status']) {
            didAccept = true;
            whitelistProvider.receivedInvites[widget.index].didAccept = true;
          }

          setState(() => arePerformingAction = false);
        }
      },
      color: primary,
      width: 100,
      child: arePerformingAction ? const LoadingSpinner() : const Text("Accept"),
    );
  }

  Widget _declineButton(BuildContext context, WhitelistProvider whitelistProvider, UserProvider userProvider) {
    return PillButton(
      onTap: () async {
        if (arePerformingAction) return; // prevents spam
        bool? confirmDecline = await showConfirmModal(message: "Decline Invite");

        if (confirmDecline ?? false) {
          setState(() => arePerformingAction = true);

          final res = await whitelistProvider.declineWhitelistInvite(inviteId: widget.inviteId, headers: userProvider.requestHeaders);
          if (res['status']) {
            didDecline = true;
            whitelistProvider.receivedInvites[widget.index].didDecline = true;
          }

          setState(() => arePerformingAction = false);
        }
      },
      color: Colors.red,
      width: 100,
      child: arePerformingAction ? const LoadingSpinner() : const Text("Decline"),
    );
  }
}
