import 'package:sober_driver_analog/domain/firebase/penalties/model/penalty.dart';
import 'package:sober_driver_analog/domain/firebase/penalties/repository.dart';

class GetPenalties {
  final PenaltyRepository repository;

  GetPenalties(this.repository);

  Future<List<Penalty>> call () => repository.getPenalties();
}