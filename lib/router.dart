import 'package:flutter/material.dart';

import 'package:nerajima/root.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    if (settings.name == AppRoot.route) {
      return MaterialPageRoute(builder: (_) => const AppRoot());
    } else {
      return _notFoundRoute();
    }
  }

  static Route<dynamic> _notFoundRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return const Scaffold(body: Center(child: Text("Page not found!")));
      },
    );
  }
}
