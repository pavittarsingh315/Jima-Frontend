import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color primary = Color(0xFF6880fc);
const Color secondary = Color(0xFF9CACFF);
const Color tertiary = Color(0xFFF1E6FF);
const Color darkModeBackgroundContrast = Color(0xFF151515);
const Color lightModeBackgroundContrast = Color(0xFFf6f6f6);
const double sigmaValue = 11;

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _alreadyGotTheme = false;

  ThemeMode get themeMode => _themeMode;
  bool get gotTheme => _alreadyGotTheme;
  bool get isDarkModeEnabled => _themeMode == ThemeMode.dark;

  Future<void> getTheme() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _alreadyGotTheme = true;
    _themeMode = ThemeMode.light;
    debugPrint("got theme");
  }

  static final darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      foregroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
    ),
    colorScheme: const ColorScheme.dark(),
    brightness: Brightness.dark,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: primary, selectionColor: secondary),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: Colors.black,
    hintColor: Colors.grey[400],
  );

  static final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      foregroundColor: Colors.black,
      elevation: 0.0,
      centerTitle: true,
    ),
    colorScheme: const ColorScheme.light(),
    brightness: Brightness.light,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: primary, selectionColor: tertiary),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: Colors.white,
  );
}
