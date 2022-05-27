import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/router/router.gr.dart';
import 'package:nerajima/providers/auth_provider.dart';
import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';

class AppTrunk extends StatelessWidget {
  const AppTrunk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(context.router.currentPath);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    return const AutoTabsScaffold(
      routes: [
        HomeRouter(),
        BrowseRouter(),
        CreateRouter(),
        InboxRouter(),
        ProfileRouter(),
      ],
    );
  }
}
