import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nerajima/pages/authentication/verify_reset_code.dart';
import 'package:provider/provider.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:nerajima/providers/auth_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/components/pill_button.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/utils/phone_validator.dart';
import 'package:nerajima/utils/show_alert.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class RequestPasswordReset extends StatefulWidget {
  const RequestPasswordReset({Key? key}) : super(key: key);

  @override
  State<RequestPasswordReset> createState() => _RequestPasswordResetState();
}

class _RequestPasswordResetState extends State<RequestPasswordReset> {
  final formKey = GlobalKey<FormState>();
  bool contactIsPhone = true;
  bool filledOutForm = false;
  bool isRequesting = false;
  late final TextEditingController contactController;

  @override
  void initState() {
    super.initState();
    contactController = TextEditingController();
  }

  @override
  void dispose() {
    contactController.dispose();
    super.dispose();
  }

  void checkIfFormIsFilled(_) {
    if (contactController.text != "") {
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

    Future<void> _requestReset() async {
      if (isRequesting) return;
      final form = formKey.currentState;
      FocusManager.instance.primaryFocus?.unfocus();
      if (form!.validate()) {
        form.save();
        try {
          isRequesting = true;
          final String contact = contactIsPhone ? "+${toNumericString(contactController.text)}" : contactController.text;
          final res = await authProvider.requestPasswordReset(contact: contact);
          isRequesting = false;
          if (res["status"]) {
            context.router.pushNativeRoute(
              SwipeablePageRoute(
                builder: (context) => VerifyPasswordResetCode(
                  originalContact: contactController.text,
                  formattedContact: contact,
                ),
              ),
            );
          } else {
            showAlert(msg: res["message"], context: context, isError: true);
          }
        } catch (e) {
          isRequesting = false;
          showAlert(msg: "Could not connect to server...", context: context, isError: true);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Center(
        child: SizedBox(
          width: size.width * 0.8,
          child: Form(
            key: formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                SizedBox(height: size.height * 0.03),
                Text(
                  contactIsPhone ? "Enter your phone number to receive a reset code." : "Enter your email to receive a reset code.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: contactController,
                    textInputAction: TextInputAction.go,
                    keyboardType: contactIsPhone ? TextInputType.number : TextInputType.emailAddress,
                    inputFormatters: [if (contactIsPhone) PhoneInputFormatter()],
                    validator: MultiValidator([
                      contactIsPhone ? PhoneValidator(errorText: "Include Country Code") : EmailValidator(errorText: "Invalid Email"),
                    ]),
                    onChanged: checkIfFormIsFilled,
                    onEditingComplete: filledOutForm ? _requestReset : null,
                    decoration: InputDecoration(
                      hintText: contactIsPhone ? "Phone Number" : "Email",
                      errorStyle: const TextStyle(fontSize: 14.0),
                      filled: true,
                      fillColor: darkModeIsEnabled ? darkModeBackgroundContrast : lightModeBackgroundContrast,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11.0),
                        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          contactController.text = "";
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            contactIsPhone = !contactIsPhone;
                            filledOutForm = false;
                          });
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Icon(
                          contactIsPhone ? Icons.phone_iphone_rounded : Icons.email_rounded,
                          color: primary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    return PillButton(
                      onTap: _requestReset,
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
