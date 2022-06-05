import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoadingSpinner extends StatelessWidget {
  final Color color;
  final double size;

  const LoadingSpinner({
    Key? key,
    this.color = Colors.white,
    this.size = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(
        color: color,
        radius: size / 2,
      );
    } else {
      return SizedBox(
        height: size,
        width: size,
        child: Center(
          child: CircularProgressIndicator(
            color: color,
            strokeWidth: 2,
          ),
        ),
      );
    }
  }
}
