import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/whitelist_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/components/profile_preview_card.dart';

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
        await whitelistProvider.getReceivedInvites(authToken: userProvider.user.access, userId: userProvider.user.userId, headers: userProvider.requestHeaders);
      }
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.offset) {
          await whitelistProvider.getReceivedInvites(authToken: userProvider.user.access, userId: userProvider.user.userId, headers: userProvider.requestHeaders);
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
