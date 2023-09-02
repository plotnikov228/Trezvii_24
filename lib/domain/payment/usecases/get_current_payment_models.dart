import 'package:sober_driver_analog/domain/payment/repository/repostitory.dart';

import '../models/card.dart';
import '../models/payment_ui_model.dart';

class GetCurrentPaymentModels {
  final PaymentRepository repository;

  GetCurrentPaymentModels(this.repository);

  List<PaymentUiModel> call(bool functionalOn,
      {Function? onPromoTap,
      Function? onBonusTap,
      Function? onCashTap,
      Function? onCardTap,
      List<UserCard> cards = const []}) {
    return repository.getCurrentPaymentUiModels(functionalOn,
        onBonusTap: onBonusTap,
        onCardTap: onCardTap,
        onCashTap: onCashTap,
        onPromoTap: onPromoTap,
        cards: cards);
  }
}
