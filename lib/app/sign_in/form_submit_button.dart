import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    required String text,
     VoidCallback? onPress,
  }) : super(
            color: Colors.indigo,
            height: 44.0,
            onPressed: onPress!,
            child: Text(
              (text),
              style: const TextStyle(fontSize: 20.0, color: Colors.white),
            ),
      borderRadius: 4.0);
}
