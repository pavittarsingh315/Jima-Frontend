import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'package:nerajima/providers/auth_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/authentication/reset_password.dart';
import 'package:nerajima/components/resend_code.dart';
import 'package:nerajima/utils/show_alert.dart';

class VerifyPasswordResetCode extends StatelessWidget {
  static const String route = "/verifyPasswordResetCode";

  final String originalContact, formattedContact;
  const VerifyPasswordResetCode({Key? key, required this.originalContact, required this.formattedContact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    void pushPasswordReset({required String code}) {
      pushNewScreenWithRouteSettings(
        context,
        screen: ResetPassword(code: code, contact: formattedContact),
        settings: const RouteSettings(name: ResetPassword.route),
      );
    }

    Future<void> _onCodeInputted(String code) async {
      try {
        final res = await authProvider.verifyPasswordResetCode(code: code, contact: formattedContact);
        if (res["status"]) {
          pushPasswordReset(code: code);
        } else {
          showAlert(msg: res["message"], context: context, isError: true);
        }
      } catch (e) {
        showAlert(msg: "Could not connect to server...", context: context, isError: true);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Reset")),
      body: Center(
        child: SizedBox(
          width: size.width * 0.8,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              SizedBox(height: size.height * 0.03),
              Text(
                "Enter the six digit code sent to $originalContact",
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
