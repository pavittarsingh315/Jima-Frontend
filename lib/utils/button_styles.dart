import 'package:flutter/material.dart';

ButtonStyle noSplashButtonStyle() {
  return ButtonStyle(
    overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Colors.transparent),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11),
      ),
    ),
    side: MaterialStateProperty.all(BorderSide(color: Colors.grey.shade700, width: 0.3)),
  );
}
