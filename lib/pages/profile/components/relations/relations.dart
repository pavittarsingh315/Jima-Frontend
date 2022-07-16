import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/profile/components/relations/followers_list.dart';
import 'package:nerajima/pages/profile/components/relations/following_list.dart';
import 'package:nerajima/pages/profile/components/relations/whitelist_list.dart';

class Relations extends StatefulWidget {
  static const String route = "/relations";

  final int initialTabIndex;
  final String profileId, profileUsername;
  const Relations({Key? key, required this.initialTabIndex, required this.profileId, required this.profileUsername}) : super(key: key);

  @override
  State<Relations> createState() => _RelationsState();
}

class _RelationsState extends State<Relations> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: widget.initialTabIndex, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) HapticFeedback.lightImpact();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.profileUsername}'s"),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TabBar(
            controller: _tabController,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 0.66, color: primary),
              insets: EdgeInsets.symmetric(horizontal: 22.0),
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
            tabs: [
              Tab(child: _tabBody(context, "Followers")),
              Tab(child: _tabBody(context, "Whitelist")),
              Tab(child: _tabBody(context, "Following")),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FollowersList(profileId: widget.profileId),
                WhitelistList(profileId: widget.profileId),
                FollowingList(profileId: widget.profileId, profileUsername: widget.profileUsername),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBody(BuildContext context, String label) {
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: darkModeIsOn ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
