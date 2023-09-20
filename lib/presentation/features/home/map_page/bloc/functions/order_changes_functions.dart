import 'dart:async';

import 'package:sober_driver_analog/data/firebase/order/repository.dart';
import 'package:sober_driver_analog/extensions/order_extension.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';

import '../../../../../../domain/firebase/order/model/order.dart';
import '../../../../../../domain/firebase/order/model/order_with_id.dart';
import '../../../../../../domain/firebase/order/usecases/get_your_orders.dart';
import '../../../../../../domain/firebase/order/usecases/set_changes_order_listener.dart';
import '../event/event.dart';

class OrderChangesFunctions {
  final MapBloc bloc;

  OrderChangesFunctions(this.bloc);

  List<OrderWithId> activeOrders = [];
  StreamSubscription? _orderStateChangesListener;

  final _orderRepo = OrderRepositoryImpl();

  Order? currentOrder;
  String? currentOrderId;

  void setOrderListeners() {
    _orderStateChangesListener = SetChangesOrderListener(_orderRepo)
        .call(currentOrderId!)
        .listen((event) async {
      if (currentOrder!.status != event?.status && event != null) {
        currentOrder = event;
        bloc.add(RecheckOrderMapEvent());
      }
      activeOrders = (await GetYourOrders(_orderRepo).call())
          .where((element) =>
      element.order.isActive())
          .toList();
    });
  }

  void disposeOrderListener () {
    if(_orderStateChangesListener != null) {
      _orderStateChangesListener!.cancel();
      _orderStateChangesListener = null;
    }
  }

  void goToAcceptedInFuture(Order order, Duration duration,
      {required Duration onRetry}) {
    Future.delayed(Duration(minutes: duration.inMinutes), () {
      if (activeOrders.isNotEmpty) {
        OrderWithId nearestOrder =
        activeOrders.nearestOrder();

        if (nearestOrder.order == order) {
          currentOrder = order;
          bloc.add(RecheckOrderMapEvent());
        } else if (onRetry.inMinutes > 2) {
          goToAcceptedInFuture(order, onRetry,
              onRetry: Duration(minutes: onRetry.inMinutes ~/ 2));
        }
      }
    });
  }

}

