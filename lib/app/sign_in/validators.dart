abstract class StringValidator{
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator{
  @override
  bool isValid(String value) {
    return  value.isNotEmpty;
  }

}

class EmailAndPasswordValidator{
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();

  final String inValidEmailErrorText = 'email can\'t be empty';
  final String inValidPasswordErrorText = 'password can\'t be empty';
}