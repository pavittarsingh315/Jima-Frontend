import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:nerajima/router/router.gr.dart';
import 'package:nerajima/providers/auth_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/components/pill_button.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/utils/show_alert.dart';

class ResetPassword extends StatefulWidget {
  final String code, contact;
  const ResetPassword({Key? key, required this.code, required this.contact}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  bool isPasswordHidden = true;
  bool filledOutForm = false;
  bool isResetting = false;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void checkIfFormIsFilled(_) {
    if (passwordController.text != "") {
      if (!filledOutForm) {
        filledOutForm = true;
        setState(() {});
      }
    } else {
      if (filledOutForm) {
        filledOutForm = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool darkModeIsEnabled = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    final size = MediaQuery.of(context).size;

    Future<void> _onResetTap() async {
      if (isResetting) return;
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();
        try {
          isResetting = true;
          final res = await authProvider.confirmPasswordReset(code: widget.code, contact: widget.contact, password: passwordController.text);
          isResetting = false;
          if (res["status"]) {
            showAlert(msg: "You're good to go 🚀🚀", context: context, isError: false);
          } else {
            showAlert(msg: res["message"], context: context, isError: true);
          }
        } catch (e) {
          isResetting = false;
          showAlert(msg: "Could not connect to server...", context: context, isError: true);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("New Password")),
      body: Center(
        child: SizedBox(
          width: size.width * 0.8,
          child: Form(
            key: formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                SizedBox(height: size.height * 0.03),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: passwordController,
                    textInputAction: TextInputAction.go,
                    obscureText: isPasswordHidden,
                    onChanged: checkIfFormIsFilled,
                    onEditingComplete: filledOutForm ? _onResetTap : null,
                    validator: MultiValidator([MinLengthValidator(10, errorText: "Password must be at least 10 characters.")]),
                    decoration: InputDecoration(
                      hintText: "Password",
                      errorStyle: const TextStyle(fontSize: 14.0),
                      filled: true,
                      fillColor: darkModeIsEnabled ? darkModeBackgroundContrast : lightModeBackgroundContrast,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11.0),
                        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Icon(
                          isPasswordHidden ? Icons.visibility_off_rounded : Icons.visibility,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                ),
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    return PillButton(
                      onTap: _onResetTap,
                      color: primary,
                      enabled: filledOutForm,
                      child: auth.resetPasswordStatus == Status.requestingReset ? const LoadingSpinner() : const Text("Request Reset", style: TextStyle(fontSize: 15)),
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
