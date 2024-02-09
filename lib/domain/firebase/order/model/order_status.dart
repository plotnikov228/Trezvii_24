abstract class OrderStatus {
  @override
  String toString();

  int stage();
}

class ActiveOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Active';
  }

  @override
  int stage() {
    // TODO: implement stage
    return 2;
  }
}

class WaitingForOrderAcceptanceOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Waiting for order acceptance';
  }

  @override
  int stage() {
    return 0;
  }
}

class CancelledOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Cancelled';
  }

  @override
  int stage() {
    // TODO: implement stage
    return 3;
  }
}

class SuccessfullyCompletedOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Successfully completed';
  }

  @override
  int stage() {
    // TODO: implement stage
    return 3;
  }
}

class OrderCancelledByDriverOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Order cancelled by driver';
  }

  @override
  int stage() {
    // TODO: implement stage
    return 3;
  }
}

class OrderAcceptedOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Order accepted';
  }

  @override
  int stage() {
    // TODO: implement stage
    return 1;
  }
}

class EmergencyCancellationOrderStatus extends OrderStatus {
  @override
  String toString() {
    // TODO: implement toString
    return 'Emergency cancellation';
  }

  @override
  int stage() {
    // TODO: implement stage
    return 3;
  }
}