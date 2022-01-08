import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton(
      {required String assetName,
      required String text,
      required Color textColor,
      required Color color,
      required VoidCallback onpress})
      : assert(assetName!=null && text != null),super(
          color: color,
          borderRadious: 4.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15.0,
                ),
              ),
              Opacity(opacity: 0.0,
              child: Image.asset(assetName),
              ),
            ],
          ),
          onPress: onpress,
          height: 40,
        );
}
