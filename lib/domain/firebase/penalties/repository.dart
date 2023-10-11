import 'package:sober_driver_analog/domain/firebase/penalties/model/penalty.dart';
import 'package:sober_driver_analog/domain/payment/models/card.dart';

abstract class PenaltyRepository {
  Future<List<Penalty>> getPenalties ();

  Future deletePenalty (Penalty penalty);

  Future addPenalty (Penalty penalty);
}