import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

void showAlert({required String msg, required BuildContext context, required bool isError}) async {
  await Flushbar(
    message: msg,
    backgroundColor: isError ? Colors.red : Colors.green,
    margin: const EdgeInsets.all(20),
    borderRadius: BorderRadius.circular(10),
    icon: const Icon(Icons.error, color: Colors.white),
    forwardAnimationCurve: Curves.decelerate,
    blockBackgroundInteraction: true,
    routeBlur: 4,
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}
