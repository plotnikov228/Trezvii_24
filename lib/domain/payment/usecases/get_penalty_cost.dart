import '../models/card.dart';
import '../repository/repostitory.dart';

class GetPenaltyCost {
  final PaymentRepository repository;

  GetPenaltyCost(this.repository);

  Future<double> call() async {
    return await repository.getPenaltyCost();
  }
}