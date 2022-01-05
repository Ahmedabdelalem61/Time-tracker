import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key,required this.onSignOut,required this.auth}) : super(key: key);
  late VoidCallback onSignOut ;
  late final AuthBase auth;

  Future<void> _signOutAnonymously()async {
    try{
      await auth.signOut();
      onSignOut();
    }catch(e){
        print(e);
    }

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text('Home Page'),
            actions: [
              ElevatedButton(onPressed: _signOutAnonymously, child: const Text('Logout',style: TextStyle(fontSize: 18.0,color: Colors.white),))
            ],
          ),
        );
  }


}
