import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/whitelist_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/components/profile_preview_card.dart';
import 'package:nerajima/components/pill_button.dart';

class RequestsSent extends StatefulWidget {
  const RequestsSent({Key? key}) : super(key: key);

  @override
  State<RequestsSent> createState() => _RequestsSentState();
}

class _RequestsSentState extends State<RequestsSent> with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      WhitelistProvider whitelistProvider = Provider.of<WhitelistProvider>(context, listen: false);

      // so that when we reopen this page, no new request is made until user scrolls to bottom
      if (whitelistProvider.sentReqPage == 1) {
        await whitelistProvider.getSentRequests(authToken: userProvider.user.access, userId: userProvider.user.userId, headers: userProvider.requestHeaders);
      }
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.offset) {
          await whitelistProvider.getSentRequests(authToken: userProvider.user.access, userId: userProvider.user.userId, headers: userProvider.requestHeaders);
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
        if (whitelist.isSentReqLoading) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: loadingBody(context),
          );
        } else if (whitelist.sentReqHasError) {
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
    if (whitelist.sentRequests.isEmpty) return emptyBody(context);

    return Scrollbar(
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: whitelist.sentRequests.length + 1,
        padding: EdgeInsets.only(bottom: navBarHeight(context)),
        itemBuilder: (context, index) {
          if (index == whitelist.sentRequests.length) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: whitelist.sentReqHasMore ? 25.0 : 0),
              child: whitelist.sentReqHasMore ? Center(child: loadingBody(context)) : const SizedBox(),
            );
          }
          return ProfilePreviewCard(
            profileId: whitelist.sentRequests[index].receiverProfile!.profileId,
            name: whitelist.sentRequests[index].receiverProfile!.name,
            username: whitelist.sentRequests[index].receiverProfile!.username,
            imageUrl: whitelist.sentRequests[index].receiverProfile!.miniProfilePicture,
            trailingWidget: SentRequestsAction(profileId: whitelist.sentRequests[index].receiverProfile!.profileId),
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
                    "No Requests",
                    style: TextStyle(fontSize: 35),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text("You currently have no requests that are pending.", textAlign: TextAlign.center),
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

class SentRequestsAction extends StatefulWidget {
  final String profileId;
  const SentRequestsAction({Key? key, required this.profileId}) : super(key: key);

  @override
  State<SentRequestsAction> createState() => _SentRequestsActionState();
}

class _SentRequestsActionState extends State<SentRequestsAction> {
  bool didRequestUser = true;
  bool arePerformingAction = false;

  @override
  Widget build(BuildContext context) {
    if (didRequestUser) {
      return _cancelButton(context);
    } else {
      return _requestButton(context);
    }
  }

  Widget _cancelButton(BuildContext context) {
    return PillButton(
      onTap: () async {
        setState(() {
          didRequestUser = false;
        });
      },
      color: Colors.red,
      width: 100,
      child: arePerformingAction ? const LoadingSpinner() : const Text("Cancel"),
    );
  }

  Widget _requestButton(BuildContext context) {
    return PillButton(
      onTap: () async {
        setState(() {
          didRequestUser = true;
        });
      },
      color: primary,
      width: 100,
      child: arePerformingAction ? const LoadingSpinner() : const Text("Request"),
    );
  }
}
