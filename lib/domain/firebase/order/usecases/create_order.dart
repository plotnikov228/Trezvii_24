import 'package:sober_driver_analog/domain/firebase/order/repository/repository.dart';

import '../model/order.dart';

class CreateOrder {
  final OrderRepository repository;

  CreateOrder(this.repository);

  Future<String?> call (Order order) {
    return repository.createOrder(order);
  }
}