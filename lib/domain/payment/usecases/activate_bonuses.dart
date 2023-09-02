import '../repository/repostitory.dart';

class ActivateBonuses {
  final PaymentRepository repository;

  ActivateBonuses(this.repository);

  Future call() async {
    return await repository.activateBonuses();
  }
}