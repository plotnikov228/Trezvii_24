import 'package:sober_driver_analog/domain/payment/repository/repostitory.dart';

import '../models/card.dart';
import '../models/payment_ui_model.dart';

class SetCurrentPaymentModel {
  final PaymentRepository repository;

  SetCurrentPaymentModel(this.repository);

  Future<PaymentUiModel> call(PaymentUiModel paymentUiModel) {
    return repository.setCurrentPaymentUiModel(paymentUiModel);
  }
}
