import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sigin_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker/app/sign_in/sign_in_button.dart';
import 'package:time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class SignInPage extends StatelessWidget {

  final SignInBloc bloc;
  SignInPage(this.bloc);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
          builder: (BuildContext context, bloc, Widget? child) =>
              SignInPage(bloc)),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(context,
        title: 'sign in failed', exception: exception);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
      print(e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
      print(e);
    }
  }

  Future<void> _signInWithAFacebook(BuildContext context) async {
    try {
      await bloc.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
      print(e);
    }
  }

  void signInWithEmail(BuildContext context) {
    Navigator.of(context).push<void>(MaterialPageRoute(
        builder: (context) => EmailSignInPage(), fullscreenDialog: true));
  }



  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2.0,
        backgroundColor: Colors.indigo,
        title: const Text('Time Tracker'),
      ),
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (BuildContext context, snapshot) {
            return _buildPadding(context, snapshot.data!);
          }),
    );
  }
  Widget _buildPadding(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeader(isLoading),
          const SizedBox(
            height: 48.0,
          ),
          SocialSignInButton(
            text: 'sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onpress: () => _signInWithGoogle(context),
            assetName: 'images/google-logo.png',
          ),
          const SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            text: 'sign in with Facebook',
            textColor: Colors.white,
            color: const Color(0xFF334F92),
            onpress: () => _signInWithAFacebook(context),
            assetName: 'images/facebook-logo.png',
          ),
          const SizedBox(
            height: 8.0,
          ),
          SignInButton(
              text: 'sign in with email',
              textColor: Colors.white,
              color: Colors.teal.shade700,
              onpress: () => signInWithEmail(context)),
          const SizedBox(
            height: 8.0,
          ),
          const Text(
            'or',
            style: TextStyle(fontSize: 16.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8.0,
          ),
          SignInButton(
              text: 'Go anonymous',
              textColor: Colors.black87,
              color: Colors.lime.shade300,
              onpress: () => _signInAnonymously(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return const Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32.0),
    );
  }
}
