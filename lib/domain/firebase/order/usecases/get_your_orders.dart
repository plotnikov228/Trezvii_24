import 'package:sober_driver_analog/domain/firebase/order/repository/repository.dart';

import '../model/order.dart';

class GetYourOrders {
  final OrderRepository repository;

  GetYourOrders(this.repository);

  Future<List<Order>> call () {
    return repository.getYourOrders();
  }
}