import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_form.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  EmailSignInPage({required this.auth});
  final AuthBase auth;


  @override
  Widget build(BuildContext context) {
    print('........${auth.currentUser}.......');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        backgroundColor: Colors.indigo,
        title: const Text('Sign in'),
      ),
      backgroundColor: Colors.grey[200],
      body:  SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child:  Card(
            child:  EmailSignInForm(auth: auth),
          ),
        ),
      ),
    );
  }

}
