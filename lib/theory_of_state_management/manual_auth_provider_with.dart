import 'package:flutter/material.dart';
import 'package:time_tracker/services/auth.dart';

class AuthProvider extends InheritedWidget {
  AuthProvider({required this.auth, required this.child, Key? key})
      : super(child: child);
  final AuthBase auth;
  final Widget child;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  //this class look like our father of the app :) he gave the ancestor the data so it's very kind
  // we need to call as   =========>  final auth = AuthProvider.of(context);
  static AuthBase? of(BuildContext context) {
    final AuthProvider? provider =
        context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    return provider!.auth;
  }
}
