import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color primary = Color(0xFF6880fc);
const Color secondary = Color(0xFF9CACFF);
const Color tertiary = Color(0xFFF1E6FF);
const Color darkModeBackgroundContrast = Color(0xFF151515);
const Color lightModeBackgroundContrast = Color(0xFFf6f6f6);

const double glassSigmaValue = 11;
const double glassOpacity = 1; // TODO: change this value to 0.75 once body extends past navbar

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _alreadyGotTheme = false;

  ThemeMode get themeMode => _themeMode;
  bool get gotTheme => _alreadyGotTheme;
  bool get isDarkModeEnabled => _themeMode == ThemeMode.dark;

  Future<void> getTheme() async {
    _alreadyGotTheme = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDarkMode = prefs.getBool('isDarkMode');
    if (isDarkMode == true && _themeMode != ThemeMode.dark) {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
    debugPrint("got theme");
  }

  Future<void> changeTheme(bool darkModeIsOn) async {
    _themeMode = darkModeIsOn ? ThemeMode.dark : ThemeMode.light;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark ? true : false);
    notifyListeners();
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
    textSelectionTheme: const TextSelectionThemeData(cursorColor: primary, selectionColor: secondary, selectionHandleColor: primary),
    cupertinoOverrideTheme: const CupertinoThemeData(primaryColor: primary), // to change selectionHandleColor on iOS
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
    textSelectionTheme: const TextSelectionThemeData(cursorColor: primary, selectionColor: tertiary, selectionHandleColor: primary),
    cupertinoOverrideTheme: const CupertinoThemeData(primaryColor: primary), // to change selectionHandleColor on iOS
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: Colors.white,
  );
}
