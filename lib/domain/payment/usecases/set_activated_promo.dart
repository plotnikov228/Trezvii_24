import '../models/promo_code.dart';
import '../repository/repostitory.dart';

class SetActivatedPromo {
  final PaymentRepository repository;

  SetActivatedPromo(this.repository);

  Future call(PromoCode promoCode) async {
    return await repository.setActivatedPromo(promoCode);
  }
}