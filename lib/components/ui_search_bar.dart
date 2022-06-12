import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';

class UISearchBar extends StatelessWidget {
  final EdgeInsets padding;
  final bool autofocus;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffix;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  const UISearchBar({
    Key? key,
    this.padding = EdgeInsets.zero,
    this.autofocus = false,
    this.controller,
    this.hintText,
    this.suffix,
    this.onChanged,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool darkModeIsOn = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    return Padding(
      padding: padding,
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: autofocus,
                textInputAction: TextInputAction.search,
                controller: controller,
                onChanged: onChanged,
                onEditingComplete: onEditingComplete,
                decoration: InputDecoration(
                  hintText: hintText,
                  contentPadding: const EdgeInsets.only(top: 0), // this centers the input with the icons
                  filled: true,
                  fillColor: darkModeIsOn ? darkModeBackgroundContrast : lightModeBackgroundContrast,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                  ),
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: Colors.grey,
                    size: 23,
                  ),
                  suffixIcon: suffix,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
