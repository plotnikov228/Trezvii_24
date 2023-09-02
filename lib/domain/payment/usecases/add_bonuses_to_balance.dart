import '../repository/repostitory.dart';

class AddBonusesToBalance {
  final PaymentRepository repository;

  AddBonusesToBalance(this.repository);

  Future<int> call(int quantity) async {
    return await repository.addBonusesToBalance(quantity);
  }
}