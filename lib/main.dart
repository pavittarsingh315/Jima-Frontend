import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_uploader/flutter_uploader.dart';

import 'package:nerajima/router.dart';

import 'package:nerajima/providers/auth_provider.dart';
import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/search_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';

void backgroundHandler() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterUploader uploader = FlutterUploader();
  uploader.progress.listen((progress) {});
  uploader.result.listen((result) {});
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterUploader().setBackgroundHandler(backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
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
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: "NeraJima",
                  themeMode: themeProvider.themeMode,
                  theme: ThemeProvider.lightTheme,
                  darkTheme: ThemeProvider.darkTheme,
                  initialRoute: "/",
                  onGenerateRoute: RouteGenerator.generateRoute,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
