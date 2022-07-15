import 'package:flutter/material.dart';

class ManageWhitelist extends StatefulWidget {
  static const String route = "/manageWhitelist";
  const ManageWhitelist({Key? key}) : super(key: key);

  @override
  State<ManageWhitelist> createState() => _ManageWhitelistState();
}

class _ManageWhitelistState extends State<ManageWhitelist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Whitelist")),
    );
  }
}
