import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/browse/search_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Center(
            child: Text(
              "Home Page",
              style: TextStyle(fontSize: 25),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _floatingActionButton(context),
          ),
        ],
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, bottom: 95),
      child: SpeedDial(
        icon: Icons.more_horiz,
        backgroundColor: primary,
        iconTheme: const IconThemeData(color: Colors.white),
        overlayOpacity: 0,
        spacing: 4,
        spaceBetweenChildren: 0,
        childrenButtonSize: const Size(64, 64),
        children: [
          SpeedDialChild(
            backgroundColor: primary,
            child: const SearchButton(),
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
