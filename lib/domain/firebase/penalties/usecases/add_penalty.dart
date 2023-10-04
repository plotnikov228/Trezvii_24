import 'package:sober_driver_analog/domain/firebase/penalties/model/penalty.dart';
import 'package:sober_driver_analog/domain/firebase/penalties/repository.dart';

class AddPenalty {
  final PenaltyRepository repository;

  AddPenalty(this.repository);

  Future call (Penalty penalty) => repository.addPenalty(penalty);
}