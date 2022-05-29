import 'package:flutter/material.dart';

import 'package:nerajima/pages/profile/components/settings/logout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Scrollbar(
        child: Center(
          child: SizedBox(
            width: size.width * 0.8,
            child: ListView(
              children: [
                const SizedBox(height: 10),
                // const ThemeSwitcher(),
                const SizedBox(height: 10),
                const Divider(
                  thickness: 0.5,
                ),
                // Row(children: const [Expanded(child: ClearCacheButton())]),
                const SizedBox(height: 10),
                Row(children: const [Expanded(child: LogoutButton())]),
                const Divider(
                  thickness: 0.5,
                ),
                _copyrightFooter(context, size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _copyrightFooter(BuildContext context, Size size) {
    return SizedBox(
      height: 33,
      width: size.width,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Copyright © 2022 Pavittar Singh\n All rights reserved",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
