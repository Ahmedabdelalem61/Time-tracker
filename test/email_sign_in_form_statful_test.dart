import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker/services/auth.dart';

class MockAuth extends Mock implements AuthBase{

}


void main(){
  MockAuth mockAuth;
  setUp((){
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSignInFrom(WidgetTester tester)async{
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_)=>MockAuth(),
        child: MaterialApp(
          home: Scaffold(
            body: EmailSignInFormStateful()
          ),
        ),
      ),
    );
  } 
}