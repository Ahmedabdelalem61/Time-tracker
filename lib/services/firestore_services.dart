import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices{
  //this type of constructor to make a singleton object that can be created once without repetition
  FirestoreServices._();
  static final instance = FirestoreServices._();

  //_collectionStream method used to call stream of docs whatever the type of the collection as it was generic
  Stream<List<T>> collectionStream<T>(
      {required String path,
        required T Function(Map<String, dynamic> data,String documentId) builder}) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapShots = reference.snapshots();
    return snapShots.map((snapshot) =>
        snapshot.docs.map((snapshot) => builder(snapshot.data(),snapshot.id)).toList());
  }


  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    print('path : $path , data : $data');
    final Reference = FirebaseFirestore.instance.doc(path);
    await Reference.set(data);
  }
}