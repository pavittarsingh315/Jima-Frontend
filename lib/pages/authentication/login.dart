import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/components/pill_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool identifierIsPhone = true;
  bool isPasswordHidden = true;
  late final TextEditingController identifierController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    identifierController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
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
        // do auth logic
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
                      controller: identifierController,
                      textInputAction: TextInputAction.next,
                      keyboardType: identifierIsPhone ? TextInputType.phone : TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: identifierIsPhone ? "Phone Number" : "Email",
                        errorStyle: const TextStyle(fontSize: 14.0),
                        filled: true,
                        fillColor: darkModeIsEnabled ? darkModeBackgroundContrast : lightModeBackgroundContrast,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11.0),
                          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            identifierController.text = "";
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              identifierIsPhone = !identifierIsPhone;
                            });
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Icon(
                            identifierIsPhone ? Icons.phone_iphone_rounded : Icons.email_rounded,
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
                      onEditingComplete: _onLoginTap,
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
                    text: "Login",
                    onTap: _onLoginTap,
                    color: primary,
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
                        onPressed: () {},
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