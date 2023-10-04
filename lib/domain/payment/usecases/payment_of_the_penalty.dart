import '../models/card.dart';
import '../repository/repostitory.dart';

class PaymentOfThePenalty {
  final PaymentRepository repository;

  PaymentOfThePenalty(this.repository);

  Future<bool> call() async {
    return await repository.paymentOfThePenalty();
  }
}