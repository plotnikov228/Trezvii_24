import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/firebase/firestore/repository.dart';

class FirebaseFirestoreRepositoryImpl extends FirebaseFirestoreRepository {
  final _instance = FirebaseFirestore.instance;

  @override
  Future<List<Map<String, dynamic>>> getCollectionsData(
      String collection) async {
    return (await _instance.collection(collection).get())
        .docs
        .map((e) => e.data()!)
        .toList();
  }
}
