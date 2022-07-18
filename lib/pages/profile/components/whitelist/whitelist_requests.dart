import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';

class WhitelistRequests extends StatefulWidget {
  static const String route = "/whitelistRequests";
  const WhitelistRequests({Key? key}) : super(key: key);

  @override
  State<WhitelistRequests> createState() => _WhitelistRequestsState();
}

class _WhitelistRequestsState extends State<WhitelistRequests> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      appBar: AppBar(title: const Text("Requests")),
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
              Tab(child: _tabBody(context, "Sent")),
              Tab(child: _tabBody(context, "Received")),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(color: Colors.red),
                Container(color: Colors.blue),
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
