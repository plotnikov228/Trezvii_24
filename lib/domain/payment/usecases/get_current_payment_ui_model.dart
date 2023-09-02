import 'package:sober_driver_analog/domain/payment/repository/repostitory.dart';

import '../models/card.dart';
import '../models/payment_ui_model.dart';

class GetCurrentPaymentModel {
  final PaymentRepository repository;

  GetCurrentPaymentModel(this.repository);

  Future<PaymentUiModel> call() {
    return repository.getCurrentPaymentUiModel();
  }
}
