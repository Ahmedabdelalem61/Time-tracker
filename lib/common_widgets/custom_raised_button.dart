import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  double borderRadious = 2;
  final VoidCallback onPress;
  double height;

  CustomRaisedButton(
      {required this.child,
      required this.color,
      required this.borderRadious,
      required this.onPress,required this.height}):assert(child != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        onPressed: onPress,
        child: child,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadious),
          ),
        ),
        color: color,
      ),
    );
  }
}
