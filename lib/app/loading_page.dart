import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_page.dart';
import 'package:time_tracker/services/auth.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key? key,required this.auth}) : super(key: key);
  late  AuthBase auth;

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {


  User? _user ;
  @override
  initState(){
    super.initState();
    _updateUser(widget.auth.currentUser);
  }

  void _updateUser(User? user){
    setState(() {
      _user = user;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_user == null) {
      return  SignIn(
          auth: widget.auth,
          onSignIn: _updateUser,
      );
    }
    return HomePage(
      auth: widget.auth,
      onSignOut: ()=>_updateUser(null),
    );
  }
}
