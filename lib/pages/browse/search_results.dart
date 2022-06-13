import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TabBar(
          isScrollable: true,
          controller: _tabController,
          indicatorColor: Colors.transparent,
          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
          tabs: [
            Tab(child: _tabBody(context, "Top")),
            Tab(child: _tabBody(context, "Users")),
            Tab(child: _tabBody(context, "Posts")),
            Tab(child: _tabBody(context, "Hashtags")),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              Center(child: Text("Top Results")),
              Center(child: Text("User Results")),
              Center(child: Text("Post Results")),
              Center(child: Text("Hashtag Results")),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabBody(BuildContext context, String label) {
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: darkModeIsOn ? darkModeBackgroundContrast : lightModeBackgroundContrast,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(label),
    );
  }
}
