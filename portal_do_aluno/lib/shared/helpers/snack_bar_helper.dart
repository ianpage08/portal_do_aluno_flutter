import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

snackBarPersonalizado({
  required BuildContext context,
  required String mensagem,
  Duration duracao = const Duration(seconds: 3),
  Color? cor,
}) {
  Flushbar(
    message: mensagem,
    duration: duracao,
    flushbarPosition: FlushbarPosition.BOTTOM,
    backgroundColor: cor ?? Colors.deepPurpleAccent,
    borderRadius: BorderRadius.circular(12),
    margin: const EdgeInsets.all(12),
  ).show(context);
}
