import 'dart:async';

import 'package:flutter/material.dart';

import 'package:nerajima/providers/theme_provider.dart';

class ResendButton extends StatefulWidget {
  const ResendButton({Key? key}) : super(key: key);

  @override
  State<ResendButton> createState() => _ResendButtonState();
}

class _ResendButtonState extends State<ResendButton> {
  int seconds = 60;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        setState(() {
          seconds = 60;
        });
        timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTimerRunning = timer == null ? false : timer!.isActive;
    if (isTimerRunning) {
      return Text(
        "$seconds",
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      return TextButton(
        onPressed: startTimer,
        style: const ButtonStyle(),
        child: const Text(
          "Resend Code",
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }
}
