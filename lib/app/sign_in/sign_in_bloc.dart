import 'dart:async';

class SignInBloc{

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoading  =>_isLoadingController.stream;

  void dispose(){
    _isLoadingController.close();
  }

  void setIsLoading (bool isLoading)=>_isLoadingController.add(isLoading);
}

