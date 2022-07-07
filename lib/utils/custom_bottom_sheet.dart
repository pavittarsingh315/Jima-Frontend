import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<Widget> children;
  const CustomBottomSheet({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    children.add(_cancelBtn(context));
    return Container(
      margin: EdgeInsets.only(
        left: size.width * 0.06,
        right: size.width * 0.06,
        bottom: 22,
      ),
      decoration: BoxDecoration(
        color: darkModeIsOn ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(11), bottom: Radius.circular(11)),
      ),
      child: Wrap(
        children: children.map((e) {
          int index = children.indexOf(e);
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: index == 0 ? 8.0 : 0), // 8 is half of the width of the divider height
                child: children[index],
              ),
              index == children.length - 1 ? const SizedBox() : const Divider(color: Colors.grey, height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _cancelBtn(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 8), // half of the width of the divider height
        child: const Center(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
