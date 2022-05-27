import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:nerajima/router/router.gr.dart';
import 'package:nerajima/providers/auth_provider.dart';
import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/models/user_model.dart';
import 'package:nerajima/components/resend_code.dart';
import 'package:nerajima/utils/show_alert.dart';

class VerifyRegistration extends StatelessWidget {
  final String originalContact, formattedContact, username, name, password;
  const VerifyRegistration({
    Key? key,
    required this.originalContact,
    required this.formattedContact,
    required this.username,
    required this.name,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    Future<void> _onCodeInputted(String code) async {
      try {
        final res = await authProvider.finalizeRegistration(code: code, contact: formattedContact, username: username, name: name, password: password);
        if (res["status"]) {
          User user = res['user'];
          userProvider.setUser(user);
          context.router.pushAndPopUntil(const AppRoot(), predicate: (route) => false);
        } else {
          showAlert(msg: res["message"], context: context, isError: true);
        }
      } catch (e) {
        showAlert(msg: "Could not connect to server...", context: context, isError: true);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Verify Registration")),
      body: Center(
        child: SizedBox(
          width: size.width * 0.8,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              SizedBox(height: size.height * 0.03),
              Text(
                "A six digit code was sent to $originalContact",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.03),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (_) {},
                animationDuration: const Duration(seconds: 0),
                keyboardType: TextInputType.number,
                autoFocus: true,
                pinTheme: PinTheme(
                  activeColor: primary,
                  selectedColor: primary,
                ),
                onCompleted: _onCodeInputted,
              ),
              SizedBox(height: size.height * 0.005),
              const Text("Code expires in 5 minutes!", textAlign: TextAlign.center),
              SizedBox(height: size.height * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Didn't receive a code?"),
                  ResendButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
