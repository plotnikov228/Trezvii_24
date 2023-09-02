import '../models/promo_code.dart';
import '../repository/repostitory.dart';

class CheckPromoForActivity {
  final PaymentRepository repository;

  CheckPromoForActivity(this.repository);

  Future<PromoCode?> call() async {
    return await repository.checkPromoForActivity();
  }
}