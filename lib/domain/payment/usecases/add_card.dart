import '../models/card.dart';
import '../repository/repostitory.dart';

class AddCard {
  final PaymentRepository repository;

  AddCard(this.repository);

  Future call(UserCard card) async {
    return await repository.addCard(card);
  }
}