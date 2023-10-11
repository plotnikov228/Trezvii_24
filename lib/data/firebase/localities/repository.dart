import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sober_driver_analog/domain/firebase/localities/repository.dart';

class LocalitiesRepositoryImpl extends LocalitiesRepository {
  final _localitiesCollection = 'Localities';
  final _instance = FirebaseFirestore.instance;
  List<String>? _localities;
  @override
  Future<List<String>> getAvailableLocalities() async {
    if(_localities != null) return _localities!;
    final col = await _instance.collection(_localitiesCollection).get();
    _localities = col.docs.map((e) => e.id).toList();
    print('localities = $_localities');
    return _localities!;
  }
}