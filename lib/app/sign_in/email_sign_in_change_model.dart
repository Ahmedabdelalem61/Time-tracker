import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInChangeModel with EmailAndPasswordValidator,ChangeNotifier{

  EmailSignInChangeModel({required this.auth, this.email = '' ,  this.password = '',  this.isLoading = false,  this.formType = EmailSignInFormType.signin,  this.submitted = false});
  final AuthBase? auth;
  String email ;
  String password ;
  bool isLoading ;
  EmailSignInFormType formType ;
  bool submitted ;

  Future<void> submit() async {
    updateWith(isLoading: true,submitted: true);
    try {
      if (formType == EmailSignInFormType.signin) {
        await auth!.signInWithEmailAndPassword(email, password);
      } else {
        await auth!.createUserWithEmailAndPassword(email, password);
      }
    }  catch (e) {
      updateWith(isLoading: false);
      rethrow ;
    }
  }
// copy with method safe me from losing my immediate data and updating any of the model attribute safely without lost
  // IMPORTANT NOTE when using bloc we use immutable version of these final var so we only inject new model to use again using copyWith method
 void updateWith({String? email,String? password,bool? submitted,bool? isLoading,EmailSignInFormType? formType}){
  this.password =  password??this.password;
  this.email = email??this.email;
  this.formType = formType??this.formType;
  this.isLoading = isLoading??this.isLoading;
  notifyListeners();
 }

  String get primaryButtonText => formType == EmailSignInFormType.signin ? 'Sign in' : 'Register';
  String get  secondaryButtonText => formType == EmailSignInFormType.signin ? 'Need an account? Register' : 'Already have an account';
  bool get canSubmit=>emailValidator.isValid(email) && passwordValidator.isValid(password) && !isLoading;
  String? get   showPasswordText {
    bool showerror = !submitted && !passwordValidator.isValid(password);
    return showerror ? inValidPasswordErrorText : null;
  }
  String? get showEmailErrorText {
    bool showerror = !submitted && !emailValidator.isValid(email);
    return showerror ? inValidEmailErrorText : null;
  }

  void toggleFormType(){
    final formtype = formType == EmailSignInFormType.signin
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


}