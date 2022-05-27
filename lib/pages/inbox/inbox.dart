import 'package:flutter/material.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inbox")),
      body: const Center(
        child: Text(
          "Inbox Page",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
