import 'package:sober_driver_analog/domain/payment/models/card.dart';

import '../models/payment_ui_model.dart';
import '../models/promo_code.dart';

abstract class PaymentRepository {
  List<PaymentUiModel> getCurrentPaymentUiModels(bool functionalOn,
      {Function? onPromoTap,
        Function? onBonusTap,
        Function? onCashTap,
        Function? onCardTap,
        List<UserCard> cards = const []});
  Future<PaymentUiModel> getCurrentPaymentUiModel();
  Future<PaymentUiModel> setCurrentPaymentUiModel(PaymentUiModel newPaymentUiModel);

  Future<PromoCode?> activatePromo(String promo);
  Future setActivatedPromo (PromoCode promoCode);
  Future<PromoCode?> checkPromoForActivity();

  Future<String> cardPay(UserCard card);

  Future<int> addBonusesToBalance(int quantity);
  Future<int> getBonusesBalance();

  Future activateBonuses();
  Future<int?> checkBonusesForActivity();
  Future spendBonuses();

  Future<double> getCosts({bool inCity = false, outCity = false});
}