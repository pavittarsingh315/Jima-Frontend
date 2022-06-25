import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/components/pill_button.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/utils/show_alert.dart';

class EditUsernamePage extends StatefulWidget {
  static const String route = "/editUsername";
  const EditUsernamePage({Key? key}) : super(key: key);

  @override
  State<EditUsernamePage> createState() => _EditUsernamePageState();
}

class _EditUsernamePageState extends State<EditUsernamePage> {
  final formKey = GlobalKey<FormState>();
  String username = "";
  bool isSaving = false, filledOutForm = true;

  @override
  Widget build(BuildContext context) {
    final bool darkModeIsEnabled = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    void popPage() {
      Navigator.of(context).pop();
    }

    Future<void> _onSave() async {
      if (isSaving) return; // prevents spam
      final form = formKey.currentState;
      FocusManager.instance.primaryFocus?.unfocus();
      if (form!.validate()) {
        form.save();
        if (username == userProvider.user.username) {
          popPage();
          return;
        }
        try {
          isSaving = true;
          final res = await userProvider.changeUsername(newUsername: username);
          isSaving = false;
          if (res["status"]) {
            popPage();
          } else {
            showAlert(msg: res["message"], context: context, isError: true);
          }
        } catch (e) {
          isSaving = false;
          showAlert(msg: "Could not connect to server...", context: context, isError: true);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Username")),
      body: Form(
        key: formKey,
        child: Center(
          child: SizedBox(
            height: size.height,
            width: size.width * 0.8,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                SizedBox(height: size.height * 0.03),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    initialValue: userProvider.user.username,
                    onEditingComplete: filledOutForm ? _onSave : null,
                    maxLength: 30,
                    onChanged: (v) {
                      if (v.trim().replaceAll(" ", "").length < 6) {
                        if (filledOutForm) {
                          setState(() {
                            filledOutForm = false;
                          });
                        }
                      } else {
                        if (!filledOutForm) {
                          filledOutForm = true;
                          setState(() {});
                        }
                      }
                    },
                    onSaved: (v) {
                      setState(() {
                        username = v!.trim().replaceAll(" ", "").toLowerCase(); // form.save(); called after form!.validate(); meaning v != null since we have MinLengthValidator
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Username",
                      errorStyle: const TextStyle(fontSize: 14.0),
                      filled: true,
                      fillColor: darkModeIsEnabled ? darkModeBackgroundContrast : lightModeBackgroundContrast,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11.0),
                        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),
                ),
                Consumer<UserProvider>(
                  builder: (context, user, child) {
                    return PillButton(
                      onTap: _onSave,
                      color: primary,
                      enabled: filledOutForm,
                      child: user.userStatus == UserStatus.updating ? const LoadingSpinner() : const Text("Save", style: TextStyle(fontSize: 15)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
