import 'package:sober_driver_analog/domain/firebase/order/model/order.dart';

import '../../../../presentation/utils/status_enum.dart';

abstract class OrderRepository {
  Future<Order?> getOrderById (String id);

  Future<String?> createOrder (Order order);

  Future<Status> deleteOrderById (String id);

  Future<List<Order>> getYourOrders ();

  Future<Order?> updateOrderById (String id, Order order);

  void setOrderChangesListener (Function(Order?) getChangedOrder, String orderId);

  void removeOrderChangesListener();


}