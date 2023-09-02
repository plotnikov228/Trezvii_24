import 'package:sober_driver_analog/domain/firebase/order/repository/repository.dart';
import 'package:sober_driver_analog/presentation/utils/status_enum.dart';

import '../model/order.dart';

class DeleteOrderById {
  final OrderRepository repository;

  DeleteOrderById(this.repository);

  Future<Status> call (String id) {
    return repository.deleteOrderById(id);
  }
}