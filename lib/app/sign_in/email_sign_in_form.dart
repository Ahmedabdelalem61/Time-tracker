
import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/form_submit_button.dart';
import 'package:time_tracker/services/auth.dart';

enum EmailSignInFormType {signin,register}

class EmailSignInForm extends StatefulWidget {
   EmailSignInForm({ required this.auth});
   final AuthBase auth ;


  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}



class _EmailSignInFormState extends State<EmailSignInForm> {

  EmailSignInFormType _formType = EmailSignInFormType.signin;
   TextEditingController _emailController = TextEditingController();
   TextEditingController _passwordController =  TextEditingController();

   String get _email =>_emailController.text;
   String get _password =>_passwordController.text;

   void submit() async {
     try{
       if(_formType==EmailSignInFormType.signin){
         await widget.auth.signInWithEmailAndPassword(_email, _password);
       }else{
         await widget.auth.createUserWithEmailAndPassword(_email, _password);
       }
       print(widget.auth);
       Navigator.of(context).pop();
     }catch(e){
       print(e);
     }
   }

   void toggleFormType(){
     setState(() {
       _formType = _formType == EmailSignInFormType.signin?EmailSignInFormType.register:EmailSignInFormType.signin;
     });
     _emailController.clear();
     _passwordController.clear();
   }

  List<Widget> _buildChilderen() {
     final primaryText = _formType == EmailSignInFormType.signin? 'Sign in' : 'Register';
     final secondaryText = _formType == EmailSignInFormType.signin? 'Need an account? Register' : 'Already have an account';

     return [
       TextField(
        decoration:const  InputDecoration(
          label: Text('Email'),
          hintText: "example@email.com",
        ),
        controller: _emailController,
         keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(
        height: 8.0,
      ),
       TextField(
        decoration: const InputDecoration(
          label: Text('Password'),
        ),
        obscureText: true,
         controller: _passwordController,
      ),
      const SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        onPress: submit,
        text: primaryText,
      ),
      const SizedBox(
        height: 8.0,
      ),
      TextButton(
          onPressed: toggleFormType, child: Text(secondaryText))
    ];
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
