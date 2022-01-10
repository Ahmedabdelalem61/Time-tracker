import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
Future<bool?>? showAlertDialog({
  required BuildContext context,
  required String title,
  String? cancelText,
  required String content,
  required String defaultActionText,
})  async {
  if (Platform.isAndroid) {
     showDialog(
       barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(

            title: Text(title),
            content: Text(content),
            actions: [
              if(cancelText!=null)
              ElevatedButton(
                  onPressed: () {
                    print('cancel pressed');
                    return Navigator.of(context).pop(false);
                  },
                  child:  Text(cancelText!)),
              ElevatedButton(
                  onPressed: (){
                    print('ok pressed');
                    return Navigator.of(context).pop(true);

                  },
                  child: Text(defaultActionText))
            ],
          );
        });
  }else {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              if(cancelText!=null)
                CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(cancelText)),
              CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(defaultActionText))
            ],
          );
        });
  }
}
