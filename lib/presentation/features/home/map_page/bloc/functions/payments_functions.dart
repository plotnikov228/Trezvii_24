import 'package:sober_driver_analog/data/payment/repository/repository.dart';

import '../../../../../../domain/payment/models/payment_ui_model.dart';
import '../../../../../../domain/payment/models/promo_code.dart';
import '../../../../../../domain/payment/usecases/check_bonuses_for_activity.dart';
import '../../../../../../domain/payment/usecases/check_promo_for_activity.dart';
import '../../../../../../domain/payment/usecases/get_bonuses_balance.dart';
import '../../../../../../domain/payment/usecases/get_current_payment_models.dart';
import '../../../../../../domain/payment/usecases/get_current_payment_ui_model.dart';

class PaymentsFunctions {
  PromoCode? activePromo;
  late int bonusesBalance;
  bool bonusesSpend = false;
  late PaymentUiModel _currentPaymentModel;

  PaymentUiModel get currentPaymentModel => _currentPaymentModel;
  void setPaymentModel (PaymentUiModel _) => _currentPaymentModel = _;
  late List<PaymentUiModel> methodsList;

  final _paymentRepo = PaymentRepositoryImpl();

  Future init () async {
    activePromo = await CheckPromoForActivity(_paymentRepo).call();
    bonusesBalance = await GetBonusesBalance(_paymentRepo).call();
    bonusesSpend =
        await CheckBonusesForActivity(_paymentRepo).call() != null;
    _currentPaymentModel = await GetCurrentPaymentModel(_paymentRepo).call();
    methodsList = GetCurrentPaymentModels(_paymentRepo).call(true);
  }
}