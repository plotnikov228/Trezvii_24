import 'package:sober_driver_analog/domain/firebase/penalties/model/penalty.dart';

import '../models/card.dart';
import '../repository/repostitory.dart';

class PaymentOfThePenalty {
  final PaymentRepository repository;

  PaymentOfThePenalty(this.repository);

  Future<bool> call({Penalty? penalty, UserCard? card}) async {
    return repository.paymentOfThePenalty(penalty: penalty, card: card);
  }
}