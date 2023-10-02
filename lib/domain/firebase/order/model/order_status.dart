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

class WaitingForOrderAcceptanceOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Waiting for order acceptance';
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

class EmergencyCancellationOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Emergency cancellation';
  }
}