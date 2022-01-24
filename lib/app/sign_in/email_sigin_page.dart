import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_form_bloc_based.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_form_change_notifier.dart';
import 'package:time_tracker/services/auth.dart';

import 'email_sign_in_form_statefull.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        backgroundColor: Colors.indigo,
        title: const Text('Sign in'),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
    );
  }
}
