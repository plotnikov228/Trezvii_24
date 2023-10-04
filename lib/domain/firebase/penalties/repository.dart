import 'package:sober_driver_analog/domain/firebase/penalties/model/penalty.dart';

abstract class PenaltyRepository {
  Future<List<Penalty>> getPenalties ();

  Future deletePenalty (String penaltyId);

  Future addPenalty (Penalty penalty);
}