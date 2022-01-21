import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/services/auth.dart';

class SignInBloc {

  final AuthBase auth;
  SignInBloc({required this.auth});

  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User?> signIn(Future<User?> Function() signInMethod)async{
    try{
      _setIsLoading(true);
      return await signInMethod();
    }catch(e){
      _setIsLoading(false);
      rethrow ;
    }
  }

  Future<User?> signInWithFacebook()async{
    return await signIn(()=> auth.signInWithFacebook());
  }

  Future<User?> signInWithGoogle() async{
    return await signIn(()=> auth.signInWithGoogle());

  }

  Future<User?> signInAnonymously() async{
    return await signIn(()=> auth.signInAnonymously());

  }
}

