import 'package:sober_driver_analog/domain/firebase/order/model/order.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_with_id.dart';

extension ListOrderExtension on List<OrderWithId> {
  OrderWithId nearestOrder () {
    return reduce((OrderWithId a, OrderWithId b) {
      Duration diffA = (a.order.startTime.difference(DateTime.now())).abs();
      Duration diffB = (b.order.startTime.difference(DateTime.now())).abs();
      return diffA.compareTo(diffB) < 0 ? a : b;
    });
  }
}