import 'package:sober_driver_analog/domain/firebase/order/model/order.dart';
import 'package:sober_driver_analog/domain/firebase/order/repository/repository.dart';

class RemoveChangesOrderListener {
  final OrderRepository repository;

  RemoveChangesOrderListener(this.repository);

  void call () {
    return repository.removeOrderChangesListener();
  }
}