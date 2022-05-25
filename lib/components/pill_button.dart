import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color color, textColor;
  final bool enabled;
  const PillButton({
    Key? key,
    required this.child,
    required this.onTap,
    required this.color,
    this.enabled = true,
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
            backgroundColor: enabled ? MaterialStateProperty.all<Color>(color) : MaterialStateProperty.all<Color>(Colors.grey),
            foregroundColor: MaterialStateProperty.all<Color>(textColor),
            overlayColor: enabled ? null : MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Colors.transparent),
          ),
          onPressed: enabled ? onTap : null,
          child: child,
        ),
      ),
    );
  }
}
