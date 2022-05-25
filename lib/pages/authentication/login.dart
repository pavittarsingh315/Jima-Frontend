import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/authentication/registration.dart';
import 'package:nerajima/components/pill_button.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/utils/phone_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool contactIsPhone = true;
  bool isPasswordHidden = true;
  bool isLoginIn = false;
  bool filledOutForm = false;
  late final TextEditingController contactController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    contactController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    contactController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void checkIfFormIsFilled(_) {
    if (contactController.text != "" && passwordController.text != "") {
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
    final size = MediaQuery.of(context).size;

    Future<void> _onLoginTap() async {
      final form = formKey.currentState;
      FocusManager.instance.primaryFocus?.unfocus();
      if (form!.validate()) {
        form.save();
        debugPrint("+${contactIsPhone ? toNumericString(contactController.text) : contactController.text}");
        debugPrint(passwordController.text);
        setState(() {
          isLoginIn = true;
        });
        await Future.delayed(const Duration(milliseconds: 1500));
        setState(() {
          isLoginIn = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
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
                      keyboardType: contactIsPhone ? TextInputType.number : TextInputType.emailAddress,
                      inputFormatters: [if (contactIsPhone) PhoneInputFormatter()],
                      validator: MultiValidator(
                        [
                          contactIsPhone ? PhoneValidator(errorText: "Include Country Code") : EmailValidator(errorText: "Invalid Email"),
                        ],
                      ),
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
                      controller: passwordController,
                      textInputAction: TextInputAction.go,
                      obscureText: isPasswordHidden,
                      onChanged: checkIfFormIsFilled,
                      onEditingComplete: filledOutForm ? _onLoginTap : null,
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
                  PillButton(
                    onTap: _onLoginTap,
                    color: primary,
                    enabled: filledOutForm,
                    child: isLoginIn ? const LoadingSpinner() : const Text("Login", style: TextStyle(fontSize: 15)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.router.pushWidget(const RegistrationPage());
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
CountryCodePicker(
        
        initialSelection: 'US',
        showCountryOnly: true,
        showOnlyCountryWhenClosed: false,
        showFlagMain: true,
        barrierColor: Colors.transparent,
        dialogBackgroundColor: darkModeIsEnabled ? Colors.grey[900] : Colors.white,
        searchDecoration: InputDecoration(
          filled: true,
          fillColor: darkModeIsEnabled ? darkModeBackgroundContrast : lightModeBackgroundContrast,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none),
          ),
          prefixIcon: const Icon(
            CupertinoIcons.search,
            color: Colors.grey,
            size: 23,
          ),
          suffixIcon: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              print('hello');
            },
            child: const Icon(
              CupertinoIcons.clear_circled,
              color: Colors.grey,
              size: 16,
            ),
          ),
        ),
      ),
*/