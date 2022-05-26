import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';

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
    final bool darkModeIsEnabled = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: enabled ? MaterialStateProperty.all<Color>(color) : MaterialStateProperty.all<Color>(darkModeIsEnabled ? const Color.fromRGBO(44, 44, 44, 1) : const Color.fromRGBO(210, 210, 210, 1)),
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
