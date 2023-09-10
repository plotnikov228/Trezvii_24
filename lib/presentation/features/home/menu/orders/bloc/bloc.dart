import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/data/firebase/auth/repository.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/get_driver_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_status.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/bloc/state.dart';

import '../../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../../data/firebase/order/repository.dart';
import '../../../../../../domain/firebase/order/model/order_with_id.dart';
import '../../../../../../domain/firebase/order/usecases/get_your_orders.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final _orderRepo = OrderRepositoryImpl();
  final _firebaseAuthRepo = FirebaseAuthRepositoryImpl();
  late final List<OrderWithId> _cancelledOrders;
  late final List<OrderWithId> _completedOrders;
  final List<Driver?> _cancelledOrderDrivers = [];
  final List<Driver?> _completedOrderDrivers = [];

  OrdersBloc(super.initialState) {
    on<InitOrdersEvent>((event, emit) async {
      final allOrders = (await GetYourOrders(_orderRepo).call());
      _cancelledOrders = allOrders
          .where((element) =>
              element.order.status.toString() ==
              CancelledOrderStatus().toString())
          .toList();
      _completedOrders = allOrders
          .where((element) =>
              element.order.status.toString() ==
              SuccessfullyCompletedOrderStatus().toString())
          .toList();
      for (var e in _cancelledOrders) {
        _cancelledOrderDrivers.add((await GetDriverById(_firebaseAuthRepo)
            .call(e.order.driverId!) as Driver?));
      }
      for (var e in _completedOrders) {
        _completedOrderDrivers.add((await GetDriverById(_firebaseAuthRepo)
            .call(e.order.driverId!) as Driver?));
      }
      emit(OrdersState(
          cancelledOrders: _cancelledOrders,
          completedOrders: _completedOrders,
          cancelledOrderDrivers: _cancelledOrderDrivers,
          completedOrderDrivers: _completedOrderDrivers));
    });
  }
}
