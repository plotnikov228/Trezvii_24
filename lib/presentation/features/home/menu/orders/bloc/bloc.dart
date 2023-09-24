import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/data/firebase/auth/repository.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/get_driver_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_status.dart';
import 'package:sober_driver_analog/presentation/app.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/orders/bloc/state.dart';
import 'package:sober_driver_analog/presentation/utils/app_operation_mode.dart';

import '../../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../../data/firebase/order/repository.dart';
import '../../../../../../domain/firebase/order/model/order_with_id.dart';
import '../../../../../../domain/firebase/order/usecases/get_your_orders.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final _orderRepo = OrderRepositoryImpl();
  final _firebaseAuthRepo = FirebaseAuthRepositoryImpl();
  late final List<OrderWithId> _otherOrders;
  late final List<OrderWithId> _completedOrders;
  OrdersBloc(super.initialState) {
    final isUser = AppOperationMode.mode == AppOperationModeEnum.user;

    on<InitOrdersEvent>((event, emit) async {
      final allOrders = (await GetYourOrders(_orderRepo).call());
      if(isUser) {
        _otherOrders = allOrders
          .where((element) =>
              element.order.status.toString() ==
              CancelledOrderStatus().toString())
          .toList();
      } else {
        _otherOrders = allOrders.where((element) =>
        element.order.status.toString() != OrderCancelledByDriverOrderStatus().toString() &&
            element.order.status.toString() != CancelledOrderStatus().toString() &&
            element.order.status.toString() != SuccessfullyCompletedOrderStatus().toString())
            .toList();
      }
      _completedOrders = allOrders
          .where((element) =>
              element.order.status.toString() ==
              SuccessfullyCompletedOrderStatus().toString())
          .toList();
      emit(OrdersState(
          otherOrders: _otherOrders,
          completedOrders: _completedOrders,));
    });
  }
}
