import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/services/auth.dart';

class HomePage extends StatelessWidget {

  Future<void> _signOut(BuildContext context)async {
    try{
      final auth = Provider.of<AuthBase>(context,listen: false);
      await auth.signOut();
    }catch(e){
        print(e);
    }
  }
// the alert dialog return always with null
  Future<void> _confirmSignOut(BuildContext context)async{
    // final _didRequestSignOut = await showAlertDialog(
    //   context:context,
    //   content: 'do you want to sign out ?',
    //   defaultActionText: 'Ok',
    //   title: 'sign out',
    //   cancelText: 'cancel',
    // );
    //
    //
    // if(_didRequestSignOut == true){
    //   _signOut();
    // }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text('Home Page'),
            actions: [
              ElevatedButton(onPressed: ()=>_signOut(context), child: const Text('Logout',style: TextStyle(fontSize: 18.0,color: Colors.white),))
            ],
          ),
        );
  }
}
