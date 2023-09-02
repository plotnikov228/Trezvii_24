import '../repository/repostitory.dart';

class GetBonusesBalance {
  final PaymentRepository repository;

  GetBonusesBalance(this.repository);

  Future<int> call() async {
    return await repository.getBonusesBalance();
  }
}