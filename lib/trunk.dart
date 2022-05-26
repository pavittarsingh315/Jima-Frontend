import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/user_provider.dart';

class AppTrunk extends StatelessWidget {
  const AppTrunk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(context.router.currentPath);
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            idk(
              "Username:\n ${userProvider.user.username}\n",
            ),
            idk("Name:\n ${userProvider.user.name}\n"),
            idk("Bio:\n ${userProvider.user.bio}\n"),
            idk("Blacklist Message:\n ${userProvider.user.blacklistMessage}\n"),
            idk("NumFollowers:\n ${userProvider.user.numFollowers}\n"),
            idk("NumWhitelisted:\n ${userProvider.user.numWhitelisted}\n"),
            idk("NumFollowing:\n ${userProvider.user.numFollowing}\n"),
            idk("Joined:\n ${userProvider.user.dateJoined}\n"),
          ],
        ),
      ),
    );
  }

  Widget idk(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12),
    );
  }
}
