import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_services.dart';

abstract class Database {
  Future<void> setJob(Job job);

  Stream<List<Job>> jobStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;

  final _services = FirestoreServices.instance;

  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  @override
  Future<void> setJob(Job job) async {
    await _services.setData(
        path: ApiPath.job(uid, job.id!), data: job.toMap(),);

  }

  @override
  Stream<List<Job>> jobStream() => _services.collectionStream(
        path: ApiPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );
}
