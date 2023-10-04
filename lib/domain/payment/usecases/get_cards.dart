import '../models/card.dart';
import '../repository/repostitory.dart';

class GetCards {
  final PaymentRepository repository;

  GetCards(this.repository);

  Future<List<UserCard>> call() async {
    return await repository.getCards();
  }
}