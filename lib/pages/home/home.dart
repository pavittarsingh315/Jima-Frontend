import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/pages/browse/search_button.dart';
import 'package:nerajima/components/visit_profile.dart';

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
      floatingActionButton: _floatingActionButton(context),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: SpeedDial(
        icon: Icons.more_horiz,
        activeIcon: Icons.close,
        backgroundColor: primary,
        iconTheme: const IconThemeData(color: Colors.white),
        animationCurve: Curves.easeIn,
        overlayOpacity: 0,
        spacing: 4,
        spaceBetweenChildren: 0,
        childrenButtonSize: const Size(64, 64),
        renderOverlay: false,
        children: [
          SpeedDialChild(
            backgroundColor: primary,
            child: Stack(
              children: const [
                Positioned.fill(child: Icon(CupertinoIcons.search, color: Colors.white)),
                SearchButton(),
              ],
            ),
          ),
          SpeedDialChild(
            backgroundColor: primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
