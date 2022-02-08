import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/app/sign_in/form_submit_button.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';


class EmailSignInFormStatefull extends StatefulWidget with EmailAndPasswordValidators{

  @override
  State<EmailSignInFormStatefull> createState() => _EmailSignInFormStatefullState();
}

class _EmailSignInFormStatefullState extends State<EmailSignInFormStatefull> {
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  bool _submited = false;
  bool _isLoading = false;

  @override
  void dispose(){
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> submit() async {

    setState(() {
      _submited = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context,listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      print(auth);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog( context,title: 'sign in fail',exception: e);
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  void editingEmailCompleted() {
    final newFocus = widget.emailValidator.isValid(_email)?_passwordFocusNode:_emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void toggleFormType() {
    setState(() {
      _submited = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChilderen() {
    final primaryText = _formType == EmailSignInFormType.signIn ? 'Sign in' : 'Register';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Already have an account';
    bool _submitEnabled = widget.emailValidator.isValid(_email) && widget.passwordValidator.isValid(_password) &&!_isLoading;

    return [
      _buildEmailTextField(),
      const SizedBox(
        height: 8.0,
      ),
      _buidPasswordTextField(),
      if (_submitEnabled)
        const SizedBox(
          height: 8.0,
        ),
      if (_submitEnabled)
        FormSubmitButton(
          onPress: submit,
          text: primaryText,
        ),
      const SizedBox(
        height: 8.0,
      ),
      TextButton(onPressed: !_isLoading?toggleFormType:null, child: Text(secondaryText))
    ];
  }

  TextField _buidPasswordTextField() {
    bool showPasswordText = _submited && !widget.emailValidator.isValid(_password);
    return TextField(
      decoration: InputDecoration(
        label: const Text('Password'),
        errorText:showPasswordText?widget.invalidPasswordErrorText : null
      ),
      obscureText: true,
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: submit,
      onChanged: (_email) => _updateState(),
      enabled: !_isLoading,
    );
  }

  TextField _buildEmailTextField() {
    bool showEmailText = _submited && !widget.emailValidator.isValid(_email);
    return TextField(
      decoration:  InputDecoration(
        label: const Text('Email'),
        hintText: "example@email.com",
          errorText:showEmailText?widget.invalidEmailErrorText:null
      ),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: editingEmailCompleted,
      onChanged: (_password) => _updateState(),
      enabled: !_isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChilderen(),
      ),
    );
  }

  void _updateState() {
    setState(() {
      print('${_email + _password}');
    });
  }
}
