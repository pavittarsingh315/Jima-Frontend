import 'package:flutter/material.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/browse/search_button.dart';

class ExpandableFAB extends StatefulWidget {
  const ExpandableFAB({Key? key}) : super(key: key);

  @override
  State<ExpandableFAB> createState() => _ExpandableFABState();
}

class _ExpandableFABState extends State<ExpandableFAB> with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController animationController;
  late Animation<Color?> animateColor;
  late Animation<double> animateIcon;
  late Animation<double> translateButton;
  final Curve curve = Curves.easeIn;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    animateIcon = Tween<double>(begin: 0, end: 1).animate(animationController);
    animateColor = ColorTween(begin: primary, end: Colors.red).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(0, 1, curve: curve),
    ));
    translateButton = Tween<double>(
      begin: 56,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: curve,
      ),
    ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
    isOpened = !isOpened;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Transform(
            transform: Matrix4.translationValues(0.0, translateButton.value * 2, 0),
            child: _addFAB(context),
          ),
          Transform(
            transform: Matrix4.translationValues(0.0, translateButton.value, 0),
            child: _searchFAB(context),
          ),
          _mainFAB(context),
        ],
      ),
    );
  }

  Widget _mainFAB(BuildContext context) {
    return FloatingActionButton(
      heroTag: "main",
      backgroundColor: animateColor.value,
      onPressed: animate,
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: animateIcon,
        color: Colors.white,
      ),
    );
  }

  Widget _searchFAB(BuildContext context) {
    return const FloatingActionButton(
      heroTag: "search",
      onPressed: null,
      backgroundColor: primary,
      child: SearchButton(),
    );
  }

  Widget _addFAB(BuildContext context) {
    return const FloatingActionButton(
      heroTag: "add",
      onPressed: null,
      backgroundColor: primary,
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}
