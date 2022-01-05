import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/sign_in_button.dart';
import 'package:time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker/services/auth.dart';

class SignIn extends StatelessWidget {

  SignIn(  {Key? key,required this.onSignIn,required this.auth}) : super(key: key);
  late final AuthBase auth;
  late void Function(User) onSignIn ;

  late final Function? onPress;
  Future<void> _signInAnonymously()async {
    try{
      final user = await auth.signInAnonymously();
      onSignIn(user);
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        backgroundColor: Colors.indigo,
        title: const Text('Time Tracker'),
      ),
      backgroundColor: Colors.grey[200],
      body: _buildPadding(),
    );
  }

  Widget _buildPadding() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32.0),
          ),
          const SizedBox(
            height: 48.0,
          ),
          SocialSignInButton(
              text: 'sign in with Google',
              textColor: Colors.black87,
              color: Colors.white,
              onpress: () {},
              assetName: 'images/google-logo.png',
              ),
          const SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
              text: 'sign in with Facebook',
              textColor: Colors.white,
              color: const Color(0xFF334F92),
              onpress: () {},
            assetName: 'images/facebook-logo.png' ,
          ),
          const SizedBox(
            height: 8.0,
          ),
          SignInButton(
              text: 'sign in with email',
              textColor: Colors.white,
              color: Colors.teal.shade700,
              onpress: () {}
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Text('or',style: TextStyle(fontSize: 16.0,color: Colors.black87),textAlign: TextAlign.center,),
          const SizedBox(
            height: 8.0,
          ),
          SignInButton(
              text: 'Go anonymous',
              textColor: Colors.black87,
              color: Colors.lime.shade300,
              onpress: _signInAnonymously
          ),
        ],
      ),
    );
  }


}
