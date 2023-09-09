import 'package:sober_driver_analog/domain/firebase/order/model/order_status.dart';

extension StringExtension on String {
  OrderStatus getOrderStatusFromString() {
    switch (this) {
      case 'Active':
        return ActiveOrderStatus();
      case 'Cancelled':
        return CancelledOrderStatus();
      case 'Order accepted':
        return OrderAcceptedOrderStatus();
      case 'Waiting for order acceptance':
        return WaitingForOrderAcceptanceOrderStatus();
      case 'Order cancelled by driver':
        return OrderCancelledByDriverOrderStatus();
      default:
        return SuccessfullyCompletedOrderStatus();
    }
  }
}
