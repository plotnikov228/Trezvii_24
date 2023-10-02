abstract class PaymentMethod {
  static PaymentMethod fromString (String val) {
    switch(val) {
      case 'Cash':
        return CashPaymentMethod();
      case 'Card':
        return CashPaymentMethod();
      default:
        return CashPaymentMethod();
    }
  }
}

class CashPaymentMethod extends PaymentMethod {
  @override
  String toString() {
    // TODO: implement toString
    return 'Cash';
  }
}

class CardPaymentMethod extends PaymentMethod {
  @override
  String toString() {
    // TODO: implement toString
    return 'Card';
  }
}