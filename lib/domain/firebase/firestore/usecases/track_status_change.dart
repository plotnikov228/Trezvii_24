import '../repository.dart';

class TrackStatusChange {
  final FirebaseFirestoreRepository repository;

  TrackStatusChange(this.repository);

  Stream<Map<String, dynamic>?> call({required String collection, required String docId}) {
    return repository.trackStatusChange(collection: collection, docId: docId);
  }
}