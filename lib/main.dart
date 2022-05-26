import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/router/router.gr.dart';
import 'package:nerajima/providers/auth_provider.dart';
import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          builder: (BuildContext context, _) {
            ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

            Future<void> _getTheme() async {
              try {
                if (!themeProvider.gotTheme) {
                  await themeProvider.getTheme();
                }
              } catch (e) {
                return Future.error(e);
              }
            }

            return FutureBuilder(
              future: _getTheme(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: "NeraJima",
                  themeMode: themeProvider.themeMode,
                  theme: ThemeProvider.lightTheme,
                  darkTheme: ThemeProvider.darkTheme,
                  routeInformationParser: _appRouter.defaultRouteParser(),
                  routerDelegate: _appRouter.delegate(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
