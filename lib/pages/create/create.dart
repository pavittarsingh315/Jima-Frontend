import 'package:flutter/material.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create")),
      body: const Center(
        child: Text(
          "Create Page",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
