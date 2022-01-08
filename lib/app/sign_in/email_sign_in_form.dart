import 'dart:io';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/form_submit_button.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

enum EmailSignInFormType { signin, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator{
  EmailSignInForm({required this.auth});

  final AuthBase auth;

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  EmailSignInFormType _formType = EmailSignInFormType.signin;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  bool _submited = false;
  bool _isLoading = false;

  void submit() async {

    setState(() {
      _submited = true;
      _isLoading = true;
    });
    try {
      if (_formType == EmailSignInFormType.signin) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      print(widget.auth);
      Navigator.of(context).pop();
    } catch (e) {
      showAlertDialog(defaultActionText: 'Ok', title: 'signing in failure', content: e.toString(), context: context,);
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
      _formType = _formType == EmailSignInFormType.signin
          ? EmailSignInFormType.register
          : EmailSignInFormType.signin;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChilderen() {
    final primaryText = _formType == EmailSignInFormType.signin ? 'Sign in' : 'Register';
    final secondaryText = _formType == EmailSignInFormType.signin
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
        errorText:showPasswordText?widget.inValidPasswordErrorText : null
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
          errorText:showEmailText?widget.inValidEmailErrorText:null
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
