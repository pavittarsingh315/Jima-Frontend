import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';

class ProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  double opacity = 0;
  final double minExtentParam, maxExtentParam, percentScrollForOpacity, opacityIncreaseSlope;
  final Widget background;
  final String username, dateJoined;
  final bool isCurrentUserProfile;
  final Widget? leading, action;
  final VoidCallback? onHeaderTap;
  final Future<void> Function()? onStrech;

  ProfileHeaderDelegate({
    required this.minExtentParam,
    required this.maxExtentParam,
    required this.percentScrollForOpacity,
    required this.opacityIncreaseSlope,
    required this.background,
    required this.username,
    required this.dateJoined,
    required this.isCurrentUserProfile,
    required this.leading,
    required this.action,
    required this.onHeaderTap,
    required this.onStrech,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final bool scrolledFarEnough = shrinkOffset >= (maxExtent - minExtent) * 0.97;
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    final double opacity = opacityCalculator(shrinkOffset);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarBrightness: determineStatusBarColor(isAndroid: false, darkModeIsOn: darkModeIsOn, scrolledFarEnough: scrolledFarEnough),
        statusBarIconBrightness: determineStatusBarColor(isAndroid: true, darkModeIsOn: darkModeIsOn, scrolledFarEnough: scrolledFarEnough),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onHeaderTap,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: darkModeIsOn ? Colors.black : Colors.white),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 1 - opacity,
                child: background,
              ),
            ),
            if (leading != null)
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                child: _buttonWrapper(
                  opacity: opacity,
                  margin: const EdgeInsets.only(left: 10, top: 6),
                  child: leading!,
                ),
              ),
            if (action != null)
              Positioned(
                top: MediaQuery.of(context).padding.top,
                right: 0,
                child: _buttonWrapper(
                  opacity: opacity,
                  margin: const EdgeInsets.only(right: 10, top: 6),
                  child: action!,
                ),
              ),
            Positioned(
              child: Align(
                child: Padding(
                  padding: EdgeInsets.only(bottom: minExtent / (dateJoined == "" ? 6 : 12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _displayUsername(
                        username: username,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: darkModeIsOn ? Colors.white.withOpacity(opacity) : Colors.black.withOpacity(opacity),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (dateJoined != "")
                        Text(
                          "Joined $dateJoined",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.withOpacity(opacity),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayUsername({required String username, required TextStyle style}) {
    if (!isCurrentUserProfile) {
      return Text(
        username,
        textAlign: TextAlign.center,
        style: style,
      );
    }

    return Consumer<UserProvider>(
      builder: (context, user, child) {
        return Text(
          user.user.username,
          textAlign: TextAlign.center,
          style: style,
        );
      },
    );
  }

  Widget _buttonWrapper({required double opacity, required EdgeInsetsGeometry? margin, required Widget child}) {
    final double backgroundOpacity = (1 - opacity <= 0.3) ? 1 - opacity : 0.3;
    final double sigma = (1 - opacity) * 100 <= 15 ? (1 - opacity) * 100 : 15;
    return Consumer<ThemeProvider>(
      builder: (context, theme, _) {
        return Container(
          margin: margin,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.isDarkModeEnabled ? Colors.black.withOpacity(backgroundOpacity) : Colors.white.withOpacity(backgroundOpacity),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: theme.isDarkModeEnabled ? Colors.black87.withOpacity(backgroundOpacity) : Colors.white30.withOpacity(backgroundOpacity)),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => maxExtentParam;

  @override
  double get minExtent => minExtentParam;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => OverScrollHeaderStretchConfiguration(stretchTriggerOffset: 200, onStretchTrigger: onStrech);

  double opacityCalculator(double shrinkOffset) {
    double maxShrinkOffset = maxExtent - minExtent; // total distance between open and closed state of this header.
    // if we've scrolled past percentScrollForOpacity start showing opacity
    if (shrinkOffset >= maxShrinkOffset * percentScrollForOpacity) {
      double x = (maxShrinkOffset * (1 - percentScrollForOpacity)) - (maxShrinkOffset - shrinkOffset);
      if (x <= 0) return 1; // safeguard because opacity < 0 == error
      opacity = opacityIncreaseSlope * x;
      if (opacity > 1) return 1; // safeguard because opacity > 1 == error
      return opacity;
    } else {
      opacity = 0;
      return opacity;
    }
  }

  Brightness determineStatusBarColor({required bool isAndroid, required bool darkModeIsOn, required bool scrolledFarEnough}) {
    if (scrolledFarEnough) {
      if (darkModeIsOn) {
        if (isAndroid) return Brightness.light; // shows white status bar
        return Brightness.dark; // shows white status bar
      } else {
        if (isAndroid) return Brightness.dark; // shows dark status bar
        return Brightness.light; // shows dark status bar
      }
    } else {
      if (isAndroid) return Brightness.light;
      return Brightness.dark;
    }
  }
}
