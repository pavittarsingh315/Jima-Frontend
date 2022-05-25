import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/components/pill_button.dart';
import 'package:nerajima/components/loading_spinner.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final formKey = GlobalKey<FormState>();
  bool contactIsPhone = true;
  bool isPasswordHidden = true;
  bool areRegistering = false;
  bool agreeToTerms = false;
  bool filledOutForm = false;
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
        print('true');
      }
    } else {
      if (filledOutForm) {
        filledOutForm = false;
        setState(() {});
        print('false');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool darkModeIsEnabled = Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    final size = MediaQuery.of(context).size;

    Future<void> _onRegisterTap() async {
      final form = formKey.currentState;
      FocusManager.instance.primaryFocus?.unfocus();
      if (form!.validate()) {
        form.save();
        debugPrint(contactController.text);
        debugPrint(usernameController.text);
        debugPrint(nameController.text);
        debugPrint(passwordController.text);
        setState(() {
          areRegistering = true;
        });
        await Future.delayed(const Duration(milliseconds: 1500));
        setState(() {
          areRegistering = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Center(
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
                            checkIfFormIsFilled(null);
                            setState(() {
                              contactIsPhone = !contactIsPhone;
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
                          if (areRegistering) return;
                          setState(() {
                            agreeToTerms = !agreeToTerms;
                          });
                          checkIfFormIsFilled(null);
                        },
                      ),
                    ],
                  ),
                  PillButton(
                    onTap: _onRegisterTap,
                    color: primary,
                    enabled: filledOutForm,
                    child: areRegistering ? const LoadingSpinner() : const Text("Register", style: TextStyle(fontSize: 15)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
