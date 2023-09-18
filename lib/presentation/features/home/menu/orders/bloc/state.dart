import '../../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../../domain/firebase/order/model/order_with_id.dart';

class OrdersState {
  final List<OrderWithId> otherOrders;
  final List<OrderWithId> completedOrders;
  final List<Driver?> otherOrderDrivers;
  final List<Driver?> completedOrderDrivers;

  OrdersState( {this.otherOrderDrivers = const[], this.completedOrderDrivers = const[], this.otherOrders = const[], this.completedOrders = const[]});
}