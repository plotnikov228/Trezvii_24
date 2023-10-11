import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sober_driver_analog/data/auth/repository/repository.dart';
import 'package:sober_driver_analog/domain/auth/usecases/get_user_id.dart';
import 'package:sober_driver_analog/domain/firebase/penalties/model/penalty.dart';

import '../../../domain/firebase/penalties/repository.dart';

class PenaltyRepositoryImpl extends PenaltyRepository {
  final _instance = FirebaseFirestore.instance;
  final _penaltyCollections = 'Penalties';
  final _authRepo = AuthRepositoryImpl();

  @override
  Future addPenalty(Penalty penalty) async {
    await _instance
        .collection(_penaltyCollections)
        .doc(await GetUserId(_authRepo).call())
        .collection(_penaltyCollections)
        .add(penalty.toJson());
  }

  @override
  Future deletePenalty(Penalty penalty) async {
    // TODO: implement deletePenalty
    final col = _instance
        .collection(_penaltyCollections)
        .doc(await GetUserId(_authRepo).call())
        .collection(_penaltyCollections);
    final doc = await col
        .where('userId', isEqualTo: penalty.userId).where('dateTime', isEqualTo: penalty.dateTime).where('cost', isEqualTo: penalty.cost).get();
    final id = doc.docs.first.id;
    await col.doc(id).delete();
  }



  @override
  Future<List<Penalty>> getPenalties() async {
    final docs = await _instance
        .collection(_penaltyCollections)
        .doc(await GetUserId(_authRepo).call())
        .collection(_penaltyCollections)
        .get();
    return docs.docs.map((e) => Penalty.fromJson(e.data())).toList();
  }
}
