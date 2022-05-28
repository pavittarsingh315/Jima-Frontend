import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:nerajima/providers/auth_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/authentication/verify_registration.dart';
import 'package:nerajima/components/pill_button.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/utils/phone_validator.dart';
import 'package:nerajima/utils/show_alert.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final formKey = GlobalKey<FormState>();
  bool contactIsPhone = true;
  bool isPasswordHidden = true;
  bool filledOutForm = false;
  bool isRegistering = false;
  bool agreeToTerms = false;
  late final TextEditingController contactController;
  late final TextEditingController usernameController;
  late final TextEditingController nameController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    contactController = TextEditingController();
    usernameController = TextEditingController();
    nameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    contactController.dispose();
    usernameController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void checkIfFormIsFilled(_) {
    if (contactController.text != "" && usernameController.text != "" && nameController.text != "" && passwordController.text != "" && agreeToTerms) {
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
    final bool darkModeIsEnabled = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    Future<void> _onRegisterTap() async {
      if (isRegistering) return; // prevents spam
      final form = formKey.currentState;
      FocusManager.instance.primaryFocus?.unfocus();
      if (form!.validate()) {
        form.save();
        try {
          isRegistering = true;
          final String contact = contactIsPhone ? "+${toNumericString(contactController.text)}" : contactController.text;
          final res = await authProvider.initiateRegistration(contact: contact, username: usernameController.text, name: nameController.text, password: passwordController.text);
          isRegistering = false;
          if (res["status"]) {
            context.router.pushNativeRoute(
              SwipeablePageRoute(
                builder: (context) => VerifyRegistration(
                  originalContact: contactController.text,
                  formattedContact: contact,
                  username: usernameController.text,
                  name: nameController.text,
                  password: passwordController.text,
                ),
              ),
            );
          } else {
            showAlert(msg: res["message"], context: context, isError: true);
          }
        } catch (e) {
          isRegistering = false;
          showAlert(msg: "Could not connect to server...", context: context, isError: true);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
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
                    controller: contactController,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    keyboardType: contactIsPhone ? TextInputType.number : TextInputType.emailAddress,
                    inputFormatters: [if (contactIsPhone) PhoneInputFormatter()],
                    validator: MultiValidator([
                      contactIsPhone ? PhoneValidator(errorText: "Include Country Code") : EmailValidator(errorText: "Invalid Email"),
                      MaxLengthValidator(50, errorText: "Contact cannot exceed 50 characters."),
                    ]),
                    onChanged: checkIfFormIsFilled,
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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: usernameController,
                    textInputAction: TextInputAction.next,
                    onChanged: checkIfFormIsFilled,
                    validator: MultiValidator([MinLengthValidator(6, errorText: "Username must be at least 6 characters."), MaxLengthValidator(30, errorText: "Username cannot exceed 30 characters.")]),
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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    onChanged: checkIfFormIsFilled,
                    validator: MultiValidator([MaxLengthValidator(30, errorText: "Name cannot exceed 30 characters.")]),
                    decoration: InputDecoration(
                      hintText: "Name",
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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: isPasswordHidden,
                    onChanged: checkIfFormIsFilled,
                    onEditingComplete: filledOutForm ? _onRegisterTap : null,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 13),
                        child: Text(
                          "I have read and agree to the Terms and Conditions and Privacy Policy.",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Checkbox(
                      value: agreeToTerms,
                      activeColor: primary,
                      onChanged: (_) {
                        if (isRegistering) return;
                        setState(() {
                          agreeToTerms = !agreeToTerms;
                          if (agreeToTerms) {
                            checkIfFormIsFilled(null);
                          } else {
                            filledOutForm = false;
                          }
                        });
                      },
                    ),
                  ],
                ),
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    return PillButton(
                      onTap: _onRegisterTap,
                      color: primary,
                      enabled: filledOutForm,
                      child: auth.authStatus == Status.registering ? const LoadingSpinner() : const Text("Register", style: TextStyle(fontSize: 15)),
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
