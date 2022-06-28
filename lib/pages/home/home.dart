import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/components/visit_profile.dart';
import 'package:nerajima/components/expandable_fab.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Home Page",
              style: TextStyle(fontSize: 25),
            ),
            ElevatedButton(
              onPressed: () {
                pushNewScreenWithRouteSettings(
                  context,
                  screen: VisitProfile(profileId: userProvider.user.profileId),
                  settings: const RouteSettings(name: VisitProfile.route),
                );
              },
              child: const Text("Visit Profile"),
            ),
          ],
        ),
      ),
      floatingActionButton: const ExpandableFAB(),
    );
  }
}
