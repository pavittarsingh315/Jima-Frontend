import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/components/pill_button.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/utils/phone_validator.dart';
import 'package:nerajima/utils/show_alert.dart';

class EditBioPage extends StatefulWidget {
  static const String route = "/editBio";
  const EditBioPage({Key? key}) : super(key: key);

  @override
  State<EditBioPage> createState() => _EditBioPageState();
}

class _EditBioPageState extends State<EditBioPage> {
  final formKey = GlobalKey<FormState>();
  String bio = "";
  bool isSaving = false;

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
        if (bio == userProvider.user.bio) {
          Navigator.of(context).pop();
          return;
        }
        try {
          isSaving = true;
          final res = await userProvider.changeBio(newBio: bio);
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
      appBar: AppBar(title: const Text("Edit Bio")),
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
                    keyboardType: TextInputType.multiline,
                    initialValue: userProvider.user.bio,
                    maxLines: null,
                    onEditingComplete: _onSave,
                    maxLength: 150,
                    onSaved: (v) {
                      setState(() {
                        bio = v!.trim(); // form.save(); called after form!.validate(); meaning v != null since we have MinLengthValidator
                      });
                    },
                    validator: LineLengthValidator(errorText: "Number of lines cannot exceed 6."),
                    decoration: InputDecoration(
                      hintText: "Bio",
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
