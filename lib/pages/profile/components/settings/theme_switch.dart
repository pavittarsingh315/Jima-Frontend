import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Dark Mode",
          style: TextStyle(fontSize: 15),
        ),
        Consumer<ThemeProvider>(
          builder: (context, theme, child) {
            return Switch.adaptive(
              value: theme.isDarkModeEnabled,
              onChanged: (value) async {
                await theme.changeTheme(value);
              },
            );
          },
        )
      ],
    );
  }
}
