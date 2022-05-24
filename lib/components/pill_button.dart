import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color color, textColor;
  const PillButton({
    Key? key,
    required this.child,
    required this.onTap,
    required this.color,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
            foregroundColor: MaterialStateProperty.all<Color>(textColor),
          ),
          onPressed: onTap,
          child: child,
        ),
      ),
    );
  }
}
