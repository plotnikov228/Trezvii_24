import 'package:sober_driver_analog/domain/firebase/order/model/order.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_with_id.dart';

extension ListOrderExtension on List<OrderWithId> {
  OrderWithId nearestOrder() {
    OrderWithId? earliestDateTime;
    if (isNotEmpty) {
      earliestDateTime = this[0];

      // Проходимся по всем элементам списка
      for (int i = 1; i < length; i++) {
        OrderWithId currentDateTime = this[i];

        // Проверяем, является ли текущий элемент раньше earliestDateTime
        if (currentDateTime.order.startTime
            .isBefore(earliestDateTime!.order.startTime)) {
          earliestDateTime = currentDateTime;
        }
      }
    }
    return earliestDateTime!;
  }
}
