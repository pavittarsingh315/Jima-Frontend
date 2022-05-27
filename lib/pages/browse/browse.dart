import 'package:flutter/material.dart';

// Use MediaQuery.of(context).padding to get all the paddings that safe area gives. use this to search bar padding from top while also not being forced to use safearea widget.

class BrowsePage extends StatelessWidget {
  const BrowsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Browse")),
      body: const Center(
        child: Text(
          "Browse Page",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
