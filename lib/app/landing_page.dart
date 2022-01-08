import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_page.dart';
import 'package:time_tracker/services/auth.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key,required this.auth}) : super(key: key);
  AuthBase auth;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(stream: auth.authStateChange(),builder: (context,snapShot){
      final User? user = snapShot.data;
      if(snapShot.connectionState == ConnectionState.active){
        if(user == null) {
          return  SignIn(
              auth: auth
          );
        }
        return HomePage(
          auth: auth,
        );
      }
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ) ,
      );
    });

  }
}
