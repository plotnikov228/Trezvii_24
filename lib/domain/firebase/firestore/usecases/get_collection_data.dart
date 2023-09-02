import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sober_driver_analog/domain/firebase/firestore/repository.dart';

class GetCollectionData {
  final FirebaseFirestoreRepository repository;

  GetCollectionData(this.repository);

  Future<List<Map<String ,dynamic>>> call (String collection)async {
    return repository.getCollectionsData(collection);
  }

}