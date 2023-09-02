import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseFirestoreRepository {
  Future<List<Map<String, dynamic>>> getCollectionsData (String collection);

}