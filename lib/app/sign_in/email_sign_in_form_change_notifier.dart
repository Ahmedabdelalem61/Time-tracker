import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/app/sign_in/form_submit_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({required this.model});

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, Widget? child) => EmailSignInFormChangeNotifier(
          model: model,
        ),
      ),
    );
  }

  @override
  State<EmailSignInFormChangeNotifier> createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState extends State<EmailSignInFormChangeNotifier> {
  EmailSignInFormType _formType = EmailSignInFormType.signin;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  EmailSignInChangeModel get model => widget.model;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    try {
      await widget.model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'sign in fail', exception: e);
    }
  }

  void editingEmailCompleted() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void toggleFormType() {
    widget.model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChilderen() {
    return [
      _buildEmailTextField(),
      const SizedBox(
        height: 8.0,
      ),
      _buidPasswordTextField(),
      if (model.canSubmit)
        const SizedBox(
          height: 8.0,
        ),
      if (model.canSubmit)
        FormSubmitButton(
          onPress: submit,
          text: model.primaryButtonText,
        ),
      const SizedBox(
        height: 8.0,
      ),
      TextButton(
          onPressed: !model.isLoading ? toggleFormType : null,
          child: Text(model.secondaryButtonText))
    ];
  }

  TextField _buidPasswordTextField() {
    return TextField(
      decoration: InputDecoration(
          label: const Text('Password'),
          errorText: model.showEmailErrorText),
      obscureText: true,
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: submit,
      onChanged: widget.model.updatePassword,
      enabled: !model.isLoading,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(
          label: const Text('Email'),
          hintText: "example@email.com",
          errorText: model.showEmailErrorText),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: () => editingEmailCompleted(),
      onChanged: widget.model.updateEmail,
      enabled: !model.isLoading,
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
}
