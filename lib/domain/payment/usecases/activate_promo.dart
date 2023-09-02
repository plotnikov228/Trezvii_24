import '../models/promo_code.dart';
import '../repository/repostitory.dart';

class ActivatePromo {
  final PaymentRepository repository;

  ActivatePromo(this.repository);

  Future<PromoCode?> call(String promo) async {
    return await repository.activatePromo(promo);
  }
}