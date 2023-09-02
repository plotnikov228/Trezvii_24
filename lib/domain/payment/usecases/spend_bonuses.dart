import '../repository/repostitory.dart';

class SpendBonuses {
  final PaymentRepository repository;

  SpendBonuses(this.repository);

  Future call() async {
    return await repository.spendBonuses();
  }
}