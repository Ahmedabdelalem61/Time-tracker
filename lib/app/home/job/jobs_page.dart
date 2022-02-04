
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/job/edit_job_page.dart';
import 'package:time_tracker/app/home/job/job_list_tile.dart';
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
        onPressed: ()=>EditJobPage.show(context,job: Job(name: 'init',ratePerHour: 0)),
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
            final children = jobs?.map((job) => JobListTile(job: job,onTap: ()=>EditJobPage.show(context,job: job),)).toList();
            return ListView(children: children!);
          }
          return const Center(child: CircularProgressIndicator(),);
        }
    );
  }


}
