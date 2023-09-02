import '../models/card.dart';
import '../repository/repostitory.dart';

class CardPay {
  final PaymentRepository repository;

  CardPay(this.repository);

  Future<String> call(UserCard card) async {
    return await repository.cardPay(card);
  }
}