abstract class OrderStatus {
  @override
  String toString();
}

class ActiveOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Active';
  }
}

class WaitingForTheDriverOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Waiting for the driver';
  }
}

class CancelledOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Cancelled';
  }
}

class SuccessfullyCompletedOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Successfully completed';
  }
}

class OrderCancelledByDriverOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Order cancelled by driver';
  }
}

class OrderAcceptedOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Order accepted';
  }
}