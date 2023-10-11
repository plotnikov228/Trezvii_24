import 'package:sober_driver_analog/domain/firebase/penalties/model/penalty.dart';
import 'package:sober_driver_analog/domain/firebase/penalties/repository.dart';

class DeletePenalty {
  final PenaltyRepository repository;

  DeletePenalty(this.repository);

  Future call (Penalty penalty) => repository.deletePenalty(penalty);
}