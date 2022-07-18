import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/profile/components/edit/edit_blacklist_message.dart';
import 'package:nerajima/pages/profile/components/whitelist/whitelist_invites.dart';
import 'package:nerajima/pages/profile/components/whitelist/whitelist_requests.dart';

class ManageWhitelist extends StatefulWidget {
  static const String route = "/manageWhitelist";
  const ManageWhitelist({Key? key}) : super(key: key);

  @override
  State<ManageWhitelist> createState() => _ManageWhitelistState();
}

class _ManageWhitelistState extends State<ManageWhitelist> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Whitelist")),
      body: Consumer<UserProvider>(
        builder: (context, user, child) {
          return Scrollbar(
            child: Center(
              child: SizedBox(
                width: size.width * 0.85,
                child: ListView(
                  padding: EdgeInsets.only(bottom: navBarHeight(context)),
                  children: [
                    SizedBox(height: size.height * 0.02),
                    _field(context, "Blacklist Msg", user.user.blacklistMessage),
                    SizedBox(height: size.height * 0.03),
                    _field(context, "Invites", ""),
                    SizedBox(height: size.height * 0.03),
                    _field(context, "Requests", ""),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field(BuildContext context, String fieldName, String fieldValue) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (fieldName == "Blacklist Msg") {
          pushNewScreenWithRouteSettings(
            context,
            screen: const EditBlacklistMessagePage(),
            settings: const RouteSettings(name: EditBlacklistMessagePage.route),
          );
        } else if (fieldName == "Invites") {
          pushNewScreenWithRouteSettings(
            context,
            screen: const WhitelistInvites(),
            settings: const RouteSettings(name: WhitelistInvites.route),
          );
        } else if (fieldName == "Requests") {
          pushNewScreenWithRouteSettings(
            context,
            screen: const WhitelistRequests(),
            settings: const RouteSettings(name: WhitelistRequests.route),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              fieldName,
              style: const TextStyle(fontSize: 16),
            ),
            if (fieldName == "Blacklist Msg")
              SizedBox(
                width: size.width * 0.42,
                child: Text(
                  fieldValue,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 17),
                ),
              )
            else
              const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
