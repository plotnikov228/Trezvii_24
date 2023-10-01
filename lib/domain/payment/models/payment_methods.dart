abstract class PaymentMethod {

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