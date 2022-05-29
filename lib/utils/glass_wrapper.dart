import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:nerajima/providers/theme_provider.dart';

class GlassWrapper extends StatelessWidget {
  final Widget child;
  final double sigma;
  final BoxShape shape;

  const GlassWrapper({
    Key? key,
    required this.child,
    this.sigma = glassSigmaValue,
    this.shape = BoxShape.rectangle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (shape == BoxShape.rectangle) {
      return ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: child,
        ),
      );
    } else {
      return ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: child,
        ),
      );
    }
  }
}
