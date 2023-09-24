import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sober_driver_analog/data/auth/repository/repository.dart';
import 'package:sober_driver_analog/data/firebase/auth/repository.dart';
import 'package:sober_driver_analog/data/firebase/order/repository.dart';
import 'package:sober_driver_analog/data/map/repository/repository.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/get_user_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/update_driver.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/update_user.dart';
import 'package:sober_driver_analog/domain/firebase/order/usecases/get_list_of_orders.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_locally.dart';
import 'package:sober_driver_analog/domain/payment/models/tariff.dart';
import 'package:sober_driver_analog/extensions/double_extension.dart';
import 'package:sober_driver_analog/extensions/order_extension.dart';
import 'package:sober_driver_analog/presentation/app.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';

import '../../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../../data/firebase/chat/repository.dart';
import '../../../../../../domain/auth/usecases/get_user_id.dart';
import '../../../../../../domain/firebase/auth/usecases/get_driver_by_id.dart';
import '../../../../../../domain/firebase/chat/usecases/delete_chat.dart';
import '../../../../../../domain/firebase/chat/usecases/find_chat.dart';
import '../../../../../../domain/firebase/order/model/order.dart';
import '../../../../../../domain/firebase/order/model/order_for_another.dart';
import '../../../../../../domain/firebase/order/model/order_status.dart';
import '../../../../../../domain/firebase/order/model/order_with_id.dart';
import '../../../../../../domain/firebase/order/usecases/create_order.dart';
import '../../../../../../domain/firebase/order/usecases/delete_order_by_id.dart';
import '../../../../../../domain/firebase/order/usecases/get_your_orders.dart';
import '../../../../../../domain/firebase/order/usecases/set_changes_order_listener.dart';
import '../../../../../../domain/firebase/order/usecases/update_order_by_id.dart';
import '../../../../../../domain/map/usecases/get_cost_in_rub.dart';
import '../../../../../../domain/map/usecases/get_routes.dart';
import '../../../../../utils/app_operation_mode.dart';
import '../../../../../utils/status_enum.dart';
import '../event/event.dart';
import '../functions.dart';
import '../state/state.dart';

class OrderChangesFunctions {
  final MapBloc bloc;
  final MapBlocFunctions mapBlocFunctions;

  OrderChangesFunctions(this.bloc, this.mapBlocFunctions);

  List<OrderWithId> activeOrders = [];
  StreamSubscription? _orderStateChangesListener;

  String? _locality;
  String? get locality => _locality;

  bool _orderIsPreliminary = false;
  DateTime? _orderStartTime;

  DateTime get orderStartTime => _orderStartTime ?? DateTime.now();
  bool get orderIsPreliminary => _orderIsPreliminary;

  void setPreliminary(bool _) => _orderIsPreliminary = _;
  void setStartTime (DateTime? _) => _orderStartTime = _;

  final _orderRepo = OrderRepositoryImpl();
  final _mapRepo = MapRepositoryImpl();
  final _fbAuthRepo = FirebaseAuthRepositoryImpl();
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

  Future initForUser() async {
    activeOrders = (await GetYourOrders(_orderRepo).call())
        .where((element) => element.order.isActive())
        .toList();
    if (activeOrders.isNotEmpty) {
      final nearestOrder =
      activeOrders.nearestOrder();
      currentOrderId = nearestOrder.id;
      currentOrder = nearestOrder.order;
      bloc.fromAddress = currentOrder!.from;
      bloc.toAddress = currentOrder!.to;

      bloc.firstAddressController.text = bloc.fromAddress!.addressName;
      bloc.secondAddressController.text = bloc.toAddress!.addressName;

      bloc.currentRoute = (await GetRoutes(_mapRepo)
          .call([bloc.fromAddress!.appLatLong, bloc.toAddress!.appLatLong]))!
          .first;
      final dur = currentOrder!.startTime.difference(DateTime.now());
      if (dur.inDays > 0) {
        _orderIsPreliminary = true;
      }
      setOrderListeners();
      if (currentOrder?.driverId != null) {
        bloc.setDriver(await GetDriverById(FirebaseAuthRepositoryImpl())
            .call(activeOrders.first.order.driverId!) as Driver?);
      }
      bloc.setGetAddressFromMap(false);
      bloc.add(RecheckOrderMapEvent());
    }
  }

  Future initForDriver () async {
    activeOrders = (await GetYourOrders(_orderRepo).call())
        .where((element) => element.order.isActive())
        .toList();
    if(activeOrders.isNotEmpty) {
      final nearestOrder = activeOrders.nearestOrder();
      currentOrderId = nearestOrder.id;
      currentOrder = nearestOrder.order;
      bloc.fromAddress = currentOrder!.from;
      bloc.toAddress = currentOrder!.to;
      bloc.currentRoute = (await GetRoutes(_mapRepo).call(
              [bloc.fromAddress!.appLatLong, bloc.toAddress!.appLatLong]))!
          .first;
      bloc.add(RecheckOrderMapEvent());
    }
    _locality = await GetLocally(_mapRepo).call();
    print('locality -  $_locality');
    if(_locality == null) {

      bloc.emit(bloc.state.copyWith(status: Status.Failed, exception: 'Не смогли определить ваш город'));
    }
  }

  Future cancelCurrentOrder (String reason) async {
    currentOrder = currentOrder!
        .copyWith(status: CancelledOrderStatus(), cancelReason: reason);
    await UpdateOrderById(_orderRepo).call(
        currentOrderId!,
        currentOrder!);
    final chatRepo = ChatRepositoryImpl();
    var chat = await FindChat(chatRepo).call(
        driverId:
        currentOrder!.driverId!,
        employerId: currentOrder!.employerId);
    if (chat != null) {
      DeleteChat(chatRepo).call(
          driverId: currentOrder!.driverId!,
          employerId: currentOrder!.employerId);
    }
    currentOrder = null;
    currentOrderId = null;
    bloc.add(RecheckOrderMapEvent());
  }



    void disposeOrderListener() {
      if (_orderStateChangesListener != null) {
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

    Future recheckOrderStatus () async {
    if(currentOrder == null) {
      if(activeOrders.isNotEmpty) {
        final nearest = activeOrders.nearestOrder();
        currentOrder = nearest.order;
        currentOrderId = nearest.id;
        if(_orderStateChangesListener == null) setOrderListeners();
      } else {
        if(_orderStateChangesListener != null) disposeOrderListener();
        bloc.add(GoMapEvent(StartOrderMapState()));
      }
    } if(currentOrder != null) {
      print(currentOrder!.status);
      switch (currentOrder!.status) {
        case WaitingForOrderAcceptanceOrderStatus():
          bloc.add(GoMapEvent(WaitingForOrderAcceptanceMapState()));
        case CancelledOrderStatus():
          bloc.add(GoMapEvent(CancelledOrderMapState()));
          mapBlocFunctions.mapFunctions.disposePositionStream();
          activeOrders.removeWhere(
                  (element) =>
              element.id ==
                  currentOrderId!);
          currentOrder = null;
          currentOrderId = null;
          bloc.add(RecheckOrderMapEvent());
        case OrderCancelledByDriverOrderStatus():
          bloc.add(GoMapEvent(OrderCancelledByDriverMapState()));
        case OrderAcceptedOrderStatus():
          var diff = currentOrder!.startTime
              .difference(DateTime.now());
          if (diff.inHours >= 1) {
            goToAcceptedInFuture(
                currentOrder!,
                Duration(minutes: diff.inMinutes - 31),
                onRetry: const Duration(minutes: 15));
            bloc.add(GoMapEvent(StartOrderMapState(
                message:
                'Водитель принял вашу заявку, за 30 минут до назначенного времени вы вернётесь в окно ожидания водителя')));
          } else {
            if(AppOperationMode.driverMode()) {
              mapBlocFunctions.mapFunctions.initPositionStream(driverMode: AppOperationMode.driverMode(), to: bloc.fromAddress?.appLatLong, whenComplete: () {
              if(AppOperationMode.driverMode()) {
                UpdateOrderById(_orderRepo).call(currentOrderId!, currentOrder!.copyWith(status: SuccessfullyCompletedOrderStatus()));
              }
            });
            }
            bloc.setDriver(await GetDriverById(FirebaseAuthRepositoryImpl()).call(currentOrder!.driverId!) as Driver);
            bloc.add(GoMapEvent(OrderAcceptedMapState()));
          }
        case SuccessfullyCompletedOrderStatus():


          bloc.add(GoMapEvent(OrderCompleteMapState()));
        case ActiveOrderStatus():
          mapBlocFunctions.mapFunctions.initPositionStream(driverMode: AppOperationMode.driverMode(), to: bloc.toAddress!.appLatLong);
          bloc.add(GoMapEvent(ActiveOrderMapState()));
      }
    }
    }

    Future createOrder (Tariff tariff, {required String wishes, required String otherName, required String otherNumber,}) async {
      final cost = await GetCostInRub(_mapRepo)
          .call(tariff, bloc.currentRoute!);
      print(cost);
      currentOrder = Order(
          WaitingForOrderAcceptanceOrderStatus(),
          from: bloc.fromAddress!,
          to: bloc.toAddress!,
          wishes:
          wishes.isNotEmpty ? wishes : null,
          distance:
          (bloc.currentRoute!.metadata.weight.distance.value! / 1000).prettify(),
          employerId: await GetUserId(AuthRepositoryImpl()).call(),
          orderForAnother: otherName.isNotEmpty &&
              otherNumber.isNotEmpty
              ? OrderForAnother(
              otherNumber, otherName)
              : null,
          startTime: orderStartTime,
          costInRub: cost);
      await CreateOrder(_orderRepo)
          .call(currentOrder!)
          .then((value) {
        currentOrderId = value;
        activeOrders.add(OrderWithId(
            currentOrder!,
            currentOrderId!));
        setOrderListeners();
        bloc.add(RecheckOrderMapEvent());
      });
    }

    Stream<List<OrderWithId>> availableOrders () => GetListOfOrders(_orderRepo).call(_locality ?? '');

  Future cancelSearch () async {
    if (currentOrder!.status
    is WaitingForOrderAcceptanceOrderStatus) {
      await DeleteOrderById(_orderRepo)
          .call(currentOrderId!);
      currentOrder = null;
      currentOrderId = null;
      disposeOrderListener();
      bloc.add(RecheckOrderMapEvent());
    }
  }

  Future completeOrder ({double? rating}) async {
    if(rating != null) {
      if(AppOperationMode.userMode()) {
        bloc.driver!.ratings.add(rating);
        await UpdateDriver(_fbAuthRepo).call(
            bloc.driver!.userId, ratings: bloc.driver!.ratings);
      } else {
        final user = await GetUserById(_fbAuthRepo).call(currentOrder!.employerId);
        if(user != null) {
          user!.ratings.add(rating);
          await UpdateUser(_fbAuthRepo).call(user.userId);
        }
      }
    }
    currentOrder = null;
    currentOrderId = null;
    bloc.setDriver(null);
    bloc.add(RecheckOrderMapEvent());

  }

  void proceedOrder () {
    UpdateOrderById(_orderRepo).call(currentOrderId!, currentOrder!.copyWith(driverId: FirebaseAuth.instance.currentUser!.uid, status: OrderAcceptedOrderStatus())).then((value) {
      setOrderListeners();
      bloc.add(RecheckOrderMapEvent());});
  }

}
