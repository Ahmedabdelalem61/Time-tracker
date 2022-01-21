import 'package:time_tracker/app/sign_in/validators.dart';

enum EmailSignInFormType { signin, register }

class EmailSignInModel with EmailAndPasswordValidator{

  EmailSignInModel({ this.email = '' ,  this.password = '',  this.isLoading = false,  this.formType = EmailSignInFormType.signin,  this.submitted = false});

  final  String email ;
  final  String password ;
  final  bool isLoading ;
  final  EmailSignInFormType formType ;
  final  bool submitted ;
// copy with method safe me from losing my immediate data and updating any of the model attribute safely without lost
 EmailSignInModel copyWith({String? email,String? password,bool? submitted,bool? isLoading,EmailSignInFormType? formType}){
   return EmailSignInModel(password: password??this.password,email: email??this.email,formType: formType??this.formType,isLoading: isLoading??this.isLoading);
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

}