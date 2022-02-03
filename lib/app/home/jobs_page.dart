
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

// the alert dialog return always with null
  Future<void> _confirmSignOut(BuildContext context) async {
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
  Future<void> _createJob(BuildContext context)async {
    try{
      final database = Provider.of<Database>(context,listen: false);
      await database.createJob(Job(name: 'sddday', ratePerHour: 20));
    }
    on FirebaseException catch(e){
      showExceptionAlertDialog(context, title: 'Operation Failed', exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Jobs'),
        actions: [
          ElevatedButton(
              onPressed: () => _signOut(context),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ))
        ],
      ),
      body: buildContents(context),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>_createJob(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildContents(BuildContext context) {
    final database = Provider.of<Database>(context,listen: false);
    return StreamBuilder<List<Job>>(
        stream: database.jobStream(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            final jobs = snapshot.data;
            final children = jobs?.map((e) => Text(e.name, style: const TextStyle(fontSize: 25),)).toList();
            return ListView(children: children!);
          }
          return const Center(child: CircularProgressIndicator(),);
        }
    );
  }


}
