import '../../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../../domain/firebase/order/model/order_with_id.dart';

class OrdersState {
  final List<OrderWithId> cancelledOrders;
  final List<OrderWithId> completedOrders;
  final List<Driver?> cancelledOrderDrivers;
  final List<Driver?> completedOrderDrivers;

  OrdersState( {this.cancelledOrderDrivers = const[], this.completedOrderDrivers = const[], this.cancelledOrders = const[], this.completedOrders = const[]});
}