import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog({required BuildContext context, required String title,required String content, required String buttonText1,required String buttonText2}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title:  Text(title),
        content:  Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child:  Text(buttonText1),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child:  Text(buttonText2),
          ),
        ],
      );
    },
  );
}
