import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobs_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_page.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context,listen: false);
    return StreamBuilder<User?>(stream: auth.authStateChange(),builder: (context,snapShot){
      final User? user = snapShot.data;
      if(snapShot.connectionState == ConnectionState.active){
        if(user == null) {
          return  SignInPage.create(context);
        }
        return Provider<Database>(
          create: (_)=> FirestoreDatabase(uid: user.uid),
            child: JobsPage());
      }
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ) ,
      );
    });

  }
}
