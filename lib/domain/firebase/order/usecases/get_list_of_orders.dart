import 'package:sober_driver_analog/domain/firebase/order/repository/repository.dart';

import '../model/order_with_id.dart';

class GetListOfOrders {
  final OrderRepository repository;

  GetListOfOrders(this.repository);

  Stream<List<OrderWithId>> call(String locality) => repository.getListOfOrders(locality);
}