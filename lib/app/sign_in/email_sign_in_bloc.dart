import 'dart:async';

import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInBloc{
  EmailSignInBloc({required this.auth});
  final AuthBase auth;

  final  StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();
   Stream<EmailSignInModel>  get modelStream => _modelController.stream ;
    EmailSignInModel _model = EmailSignInModel();

   void updateWith({String? email,String? password,bool? submitted,bool? isLoading,EmailSignInFormType? formType}){
     _model = _model.copyWith(isLoading: isLoading, formType:formType ,email:email ,password:password ,submitted:submitted );
     _modelController.add(_model);
   }

  void dispose(){
    _modelController.close();
  }


  void toggleFormType(){
     final formtype = _model.formType == EmailSignInFormType.signin
         ? EmailSignInFormType.register
         : EmailSignInFormType.signin;
    updateWith(
        submitted: false,
        isLoading: false,
        formType: formtype,
        password: '',
        email: '');
  }

  void updateEmail(String email)=>updateWith(email:email );
  void updatePassword(String password)=>updateWith(password:password );

  Future<void> submit() async {
    updateWith(isLoading: true,submitted: true);
    try {
      if (_model.formType == EmailSignInFormType.signin) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(_model.email, _model.password);
      }
    }  catch (e) {
      updateWith(isLoading: false);
      rethrow ;
    }
  }
}