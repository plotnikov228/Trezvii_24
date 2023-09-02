import 'package:sober_driver_analog/domain/firebase/order/model/order.dart';
import 'package:sober_driver_analog/domain/firebase/order/repository/repository.dart';

class SetChangesOrderListener {
  final OrderRepository repository;

  SetChangesOrderListener(this.repository);

  void call (Function(Order?) getOrder, String id) {
    return repository.setOrderChangesListener(getOrder, id);
  }
}