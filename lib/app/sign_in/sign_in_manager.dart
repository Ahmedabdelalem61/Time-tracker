import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker/services/auth.dart';

class SignInManager {

  final AuthBase auth;
  SignInManager({required this.auth,required this.isLoading});

  final ValueNotifier<bool> isLoading ;

  Future<User?> signIn(Future<User?> Function() signInMethod)async{
    try{
      isLoading.value = true;
      return await signInMethod();
    }catch(e){
      isLoading.value = false;
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

