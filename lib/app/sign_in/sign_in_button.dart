import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton(
      {required String text,
      required Color textColor,
      required Color color,
      required VoidCallback onpress})
  // i know that the assertion below always will be true
      : assert(text!= null), super(
            color: color,
            borderRadious: 4.0,
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 15.0),
            ),
            onPress: onpress,height: 40);
}
