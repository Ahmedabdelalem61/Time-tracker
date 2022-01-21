import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/app/sign_in/form_submit_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({required this.bloc});

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, Widget) => EmailSignInFormBlocBased(
          bloc: bloc,
        ),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<EmailSignInFormBlocBased> createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  EmailSignInFormType _formType = EmailSignInFormType.signin;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'sign in fail', exception: e);
    }
  }

  void editingEmailCompleted(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChilderen(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      const SizedBox(
        height: 8.0,
      ),
      _buidPasswordTextField(model),
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

  TextField _buidPasswordTextField(EmailSignInModel model) {
    return TextField(
      decoration: InputDecoration(
          label: const Text('Password'),
          errorText: model.showEmailErrorText),
      obscureText: true,
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: submit,
      onChanged: widget.bloc.updatePassword,
      enabled: !model.isLoading,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      decoration: InputDecoration(
          label: const Text('Email'),
          hintText: "example@email.com",
          errorText: model.showEmailErrorText),
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: () => editingEmailCompleted(model),
      onChanged: widget.bloc.updateEmail,
      enabled: !model.isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChilderen(model),
          ),
        );
      },
    );
  }
}
