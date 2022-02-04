import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/database.dart';

class EditJobPage extends StatefulWidget {
  EditJobPage({required this.database,required this.job});

  final Database database;
  final Job job;

  static Future<void> show(BuildContext context,{Job? job }) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditJobPage(
              job: job!,
              database: database,
            ),
        fullscreenDialog: true));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _ratePerHour;

  @override
  void initState(){
   super.initState();
   if(widget.job.name!= 'init'){
     _name = widget.job.name;
     _ratePerHour = widget.job.ratePerHour;
   }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSave()) {
      try {
        final jobs = await widget.database.jobStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if(widget.job.name == _name){
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
              context: context,
              title: 'already existing job',
              content: 'write an other job',
              defaultActionText: 'OK');
        } else {
          final id = widget.job.name!='init'?widget.job.id:DateTime.now().toIso8601String();
          print('job id    ${widget.job.id}');
          final job = Job(name: _name!, ratePerHour: _ratePerHour!,id: id);
          await widget.database.setJob(job);
          print('the setted id ${id}');
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'fail to submit', exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.job.name == 'init'?'create new job':'edit job'),
        centerTitle: true,
        elevation: 2.0,
        actions: [
          ElevatedButton(
              onPressed: _submit,
              child: const Text(
                'save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              )),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        decoration: InputDecoration(labelText: 'name'),
        onSaved: (value) => _name = value,
        validator: (value) =>
            value!.isEmpty ? 'the name must not be empty' : null,
      ),
      TextFormField(
        initialValue: widget.job.ratePerHour!=0?'$_ratePerHour':null,
        decoration: InputDecoration(labelText: 'rate per hour'),
        keyboardType: const TextInputType.numberWithOptions(
          decimal: false,
          signed: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value!)??0,
        validator: (value) =>
            value!.isEmpty ? 'rate per hour must not be empty' : null,
      ),
    ];
  }
}
