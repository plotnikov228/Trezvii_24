import '../repository/repostitory.dart';

class CheckBonusesForActivity {
  final PaymentRepository repository;

  CheckBonusesForActivity(this.repository);

  Future<int?> call() async {
    return await repository.checkBonusesForActivity();
  }
}