import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

snackBarPersonalizado({
  required BuildContext context,
  required String mensagem,
  Color? cor,
}) {
  Flushbar(
    message: mensagem,
    duration: const Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.BOTTOM,
    backgroundColor: cor ?? Colors.deepPurpleAccent,
    borderRadius: BorderRadius.circular(12),
    margin: const EdgeInsets.all(12),
  ).show(context);
}
