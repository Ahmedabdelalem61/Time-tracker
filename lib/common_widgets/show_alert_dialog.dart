import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String defaultActionText,
}) {
  if (Platform.isAndroid) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(defaultActionText))
            ],
          );
        });
  } else if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(defaultActionText))
            ],
          );
        });
  }
}
