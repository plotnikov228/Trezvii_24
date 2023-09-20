import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/data/db/repository/repository.dart';
import 'package:sober_driver_analog/data/firebase/chat/repository.dart';
import 'package:sober_driver_analog/data/firebase/firestore/repository.dart';
import 'package:sober_driver_analog/data/firebase/order/repository.dart';
import 'package:sober_driver_analog/data/map/repository/repository.dart';
import 'package:sober_driver_analog/data/payment/repository/repository.dart';
import 'package:sober_driver_analog/domain/auth/usecases/get_user_id.dart';
import 'package:sober_driver_analog/domain/db/usecases/init_db.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/get_driver_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/chat/usecases/create_chat.dart';
import 'package:sober_driver_analog/domain/firebase/chat/usecases/delete_chat.dart';
import 'package:sober_driver_analog/domain/firebase/chat/usecases/find_chat.dart';
import 'package:sober_driver_analog/domain/firebase/firestore/usecases/get_collection_data.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_for_another.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_status.dart';
import 'package:sober_driver_analog/domain/firebase/order/usecases/create_order.dart';
import 'package:sober_driver_analog/domain/firebase/order/usecases/delete_order_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/order/usecases/set_changes_order_listener.dart';
import 'package:sober_driver_analog/domain/firebase/order/usecases/update_order_by_id.dart';
import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_addresses_from_text.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_cost_in_rub.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_routes.dart';
import 'package:sober_driver_analog/domain/payment/enums/payment_types.dart';
import 'package:sober_driver_analog/domain/payment/usecases/activate_bonuses.dart';
import 'package:sober_driver_analog/domain/payment/usecases/activate_promo.dart';
import 'package:sober_driver_analog/domain/payment/usecases/check_bonuses_for_activity.dart';
import 'package:sober_driver_analog/domain/payment/usecases/check_promo_for_activity.dart';
import 'package:sober_driver_analog/domain/payment/usecases/get_bonuses_balance.dart';
import 'package:sober_driver_analog/domain/payment/usecases/get_current_payment_models.dart';
import 'package:sober_driver_analog/domain/payment/usecases/get_current_payment_ui_model.dart';
import 'package:sober_driver_analog/domain/payment/usecases/set_current_payment_ui_model.dart';
import 'package:sober_driver_analog/extensions/double_extension.dart';
import 'package:sober_driver_analog/extensions/order_extension.dart';
import 'package:sober_driver_analog/extensions/point_extension.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/functions.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/select_contact_bottom_sheet.dart';
import 'package:sober_driver_analog/presentation/routes/routes.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../../../../../../data/auth/repository/repository.dart';
import '../../../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../../../data/firebase/auth/repository.dart';
import '../../../../../../../domain/firebase/order/model/order_with_id.dart';
import '../../../../../../../domain/firebase/order/usecases/get_your_orders.dart';
import '../../../../../../../domain/map/models/address_model.dart';
import '../../../../../../../domain/payment/models/payment_ui_model.dart';
import '../../../../../../../domain/payment/models/promo_code.dart';
import '../../../../../../domain/db/constants.dart';
import '../../../../../../domain/db/usecases/db_query.dart';
import '../../../../../../domain/payment/models/tariff.dart';
import '../../../../../utils/status_enum.dart';
import '../state/state.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../event/event.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final firstAddressController = TextEditingController();
  final secondAddressController = TextEditingController();
  final _promoController = TextEditingController();
  final _otherNameController = TextEditingController();
  final _otherNumberController = TextEditingController();
  final _otherReasonForCancelOrderController = TextEditingController();
  final _wishesController = TextEditingController();
  bool _getAddressFromMap = true;

  bool get getAddressFromMap => _getAddressFromMap;

  CameraPosition? _cameraPosition;

  CameraPosition? get cameraPosition => _cameraPosition;

  void setGetAddressFromMap(bool _) => _getAddressFromMap = _;

  void setCameraPosition(CameraPosition _) => _cameraPosition = _;

  final _paymentRepo = PaymentRepositoryImpl();
  final _orderRepo = OrderRepositoryImpl();
  final _mapRepo = MapRepositoryImpl();
  final _fbAuthRepo = FirebaseAuthRepositoryImpl();
  final _authRepo = AuthRepositoryImpl();
  final _dbRepo = DBRepositoryImpl();
  MapBlocFunctions? _mapBlocFunctions;

  List<OrderWithId> get activeOrders => _mapBlocFunctions?.orderChangesFunctions.activeOrders ?? [];



  AddressModel? fromAddress;
  AddressModel? toAddress;

  MapState? previousState;
  MapState? currentState;

  DrivingRoute? currentRoute;


  PromoCode? _activePromo;
  late int _bonusesBalance;
  bool _bonusesSpend = false;

  DateTime? _orderStartTime;
  bool _orderIsPremilinary = false;

  late PaymentUiModel _currentPaymentModel;

  PaymentUiModel get currentPaymentModel => _currentPaymentModel;
  late List<PaymentUiModel> _methodsList;

  Driver? _driver;



  List<Tariff> _tariffs = [];
  int _currentTariffIndex = 0;

  MapBloc(super.initialState) {
    _mapBlocFunctions ??= MapBlocFunctions(this);
    AddressModel? _lastFavoriteAddress;
    on<InitMapBloc>((event, emit) async {
      final _favoriteAddresses = (await DBQuery(_dbRepo).call(DBConstants.favoriteAddressesTable)).map((e) => AddressModel.fromDB(e)).toList();
      if(_favoriteAddresses.isNotEmpty) {
        print('a');
        _lastFavoriteAddress = _favoriteAddresses.last;
        add(GoMapEvent(InitialMapState()));
      }

      _activePromo = await CheckPromoForActivity(_paymentRepo).call();
      _bonusesBalance = await GetBonusesBalance(_paymentRepo).call();
      _bonusesSpend =
          await CheckBonusesForActivity(_paymentRepo).call() != null;
      _currentPaymentModel = await GetCurrentPaymentModel(_paymentRepo).call();
      _methodsList = GetCurrentPaymentModels(_paymentRepo).call(true);
      await InitDB(DBRepositoryImpl()).call();
      _mapBlocFunctions!.orderChangesFunctions.activeOrders = (await GetYourOrders(_orderRepo).call())
          .where((element) => element.order.isActive())
          .toList();
      if (_mapBlocFunctions!.orderChangesFunctions.activeOrders.isNotEmpty) {
        final nearestOrder =
            activeOrders.nearestOrder();
        _mapBlocFunctions!.orderChangesFunctions.currentOrderId = nearestOrder.id;
        _mapBlocFunctions!.orderChangesFunctions.currentOrder = nearestOrder.order;
        fromAddress = _mapBlocFunctions!.orderChangesFunctions.currentOrder!.from;
        toAddress = _mapBlocFunctions!.orderChangesFunctions.currentOrder!.to;

        firstAddressController.text = fromAddress!.addressName;
        secondAddressController.text = toAddress!.addressName;

        currentRoute = (await GetRoutes(_mapRepo)
                .call([fromAddress!.appLatLong, toAddress!.appLatLong]))!
            .first;
        final dur = _mapBlocFunctions!.orderChangesFunctions.currentOrder!.startTime.difference(DateTime.now());
        if (dur.inDays > 0) {
          _orderIsPremilinary = true;
        }
        _mapBlocFunctions!.orderChangesFunctions.setOrderListeners();
        if (_mapBlocFunctions!.orderChangesFunctions.currentOrder?.driverId != null) {
          _driver = await GetDriverById(_fbAuthRepo)
              .call(_mapBlocFunctions!.orderChangesFunctions.activeOrders.first.order.driverId!) as Driver?;
        }
        setGetAddressFromMap(false);
        add(RecheckOrderMapEvent());
      }
    });

    on<GoMapEvent>((event, emit) async {
      if (currentState != null && currentState != previousState) {
        previousState = currentState;
      }
      currentState = event.newState;
      if (event.newState is InitialMapState) {
        emit(InitialMapState(lastFavoriteAddress: _lastFavoriteAddress));
      }
      if (event.newState is SelectAddressesMapState) {
        event.newState as SelectAddressesMapState;
        final _favoriteAddresses = (await DBQuery(_dbRepo).call(DBConstants.favoriteAddressesTable)).map((e) => AddressModel.fromDB(e)).toList();
        emit(SelectAddressesMapState(
          status: event.newState.status,
          autoFocusedIndex:
              (event.newState as SelectAddressesMapState).autoFocusedIndex,
          addresses: (event.newState as SelectAddressesMapState).addresses,
          favoriteAddresses:
              _favoriteAddresses,
        ));
      }
      if (event.newState is CreateOrderMapState) {
        if (_tariffs.isEmpty) {
          _tariffs = (await GetCollectionData(FirebaseFirestoreRepositoryImpl())
                  .call('Tariffs'))
              .map((e) => Tariff.fromJson(e))
              .toList();
        }

        if ((event.newState as CreateOrderMapState).currentIndexTariff !=
            _currentTariffIndex) {
          _currentTariffIndex =
              (event.newState as CreateOrderMapState).currentIndexTariff;
        }
        emit(CreateOrderMapState(
          status: event.newState.status,
          currentPaymentUiModel: _currentPaymentModel,
          currentIndexTariff: _currentTariffIndex,
          tariffList: _tariffs,
        ));
      }
      if (event.newState is SelectPaymentMethodMapState) {
        emit(SelectPaymentMethodMapState(
          status: event.newState.status,
          methods: _methodsList,
        ));
      }
      if (event.newState is WaitingForOrderAcceptanceMapState) {
        emit(WaitingForOrderAcceptanceMapState());
      }
      if (event.newState is CancelledOrderMapState) {
        emit(CancelledOrderMapState(
          status: event.newState.status,
          otherReason: _otherReasonForCancelOrderController,
          reasons: [
            'Заказал по ошибке',
            'Высокая стоимость',
            'Уехал с другим водителем',
            'Передумал ехать',
            'Недоволен водителем',
            'Долго ждать',
            'Другая причина:'
          ],
        ));
      }
      if (event.newState is ActiveOrderMapState) {
        emit(ActiveOrderMapState(
          status: event.newState.status,
        ));
      }
      if (event.newState is OrderCompleteMapState) {
        emit(OrderCompleteMapState(
            status: event.newState.status, driver: _driver));
      }
      if (event.newState is OrderCancelledByDriverMapState) {
        emit(OrderCancelledByDriverMapState(
            status: event.newState.status, driver: _driver));
      }
      if (event.newState is OrderAcceptedMapState) {
        final route = (await GetRoutes(_mapRepo).call([
          _driver!.currentPosition ?? const MoscowLocation(),
          fromAddress!.appLatLong
        ]))!
            .first;
        print(route.metadata.weight.timeWithTraffic.value! ~/ 60);
        emit(OrderAcceptedMapState(
            status: event.newState.status,
            distance: route.metadata.weight.distance.text,
            driver: _driver,
            waitingTime: _orderIsPremilinary
                ? _mapBlocFunctions!.orderChangesFunctions.currentOrder!.startTime.difference(DateTime.now())
                : _driver!.currentPosition != null
                    ? Duration(
                        minutes:
                            route.metadata.weight.timeWithTraffic.value! ~/ 60)
                    : const Duration(minutes: 15)));
      }
      if (event.newState is CheckBonusesMapState) {
        emit(CheckBonusesMapState(
            status: event.newState.status, balance: _bonusesBalance));
      }
      if (event.newState is PromoCodeMapState) {
        emit(PromoCodeMapState(
            status: event.newState.status, controller: _promoController));
      }
      if (event.newState is AddCardMapState) {
        emit(AddCardMapState(
          status: event.newState.status,
        ));
      }
      if (event.newState is AddWishesMapState) {
        emit(AddWishesMapState(
            status: event.newState.status,
            wish: _wishesController,
            otherName: _otherNameController,
            otherNumber: _otherNumberController));
      }
      if (event.newState is ActiveOrdersMapState) {
        final drivers = <Driver?>[];
        for (var item in _mapBlocFunctions!.orderChangesFunctions.activeOrders) {
          final driver = (await GetDriverById(_fbAuthRepo)
              .call(item.order.driverId ?? ''));
          drivers.add(driver as Driver?);
        }
        emit(ActiveOrdersMapState(
            status: event.newState.status,
            orders: _mapBlocFunctions!.orderChangesFunctions.activeOrders,
            drivers: drivers as List<Driver?>,
            currentOrder: _mapBlocFunctions!.orderChangesFunctions.currentOrder));
      }
      if (event.newState is AddPriceMapState) {
        emit(AddPriceMapState(order: _mapBlocFunctions!.orderChangesFunctions.currentOrder));
      }
    });

    on<SearchAddressMapEvent>((event, emit) async {
      late final List<AddressModel> result;
      if (event.address.isNotEmpty) {
        result = await GetAddressesFromText(_mapRepo)
            .call(event.address, _cameraPosition!.target.toAppLatLong());
      } else {
        result = [];
      }
      add(GoMapEvent(SelectAddressesMapState(addresses: result)));
    });

    on<GetAddressMapEvent>((event, emit) async {
      if (event.selectedAddress == 0) {
        fromAddress = event.selectedAddress;
        firstAddressController.text = fromAddress!.addressName;
      } else {
        toAddress = event.selectedAddress;
        secondAddressController.text = toAddress!.addressName;
      }
      setGetAddressFromMap(false);
      if (fromAddress != null && toAddress != null) {
        currentRoute = (await GetRoutes(_mapRepo)
                .call([fromAddress!.appLatLong, toAddress!.appLatLong]))!
            .first;
      }
      setCameraPosition(
          CameraPosition(target: event.selectedAddress!.appLatLong.toPoint()));

      add(GoMapEvent(CreateOrderMapState()));
    });

    on<CreateOrderMapEvent>((event, emit) async {
      emit(state.copyWith(status: Status.Loading));
      final cost = await GetCostInRub(_mapRepo)
          .call(_tariffs[_currentTariffIndex], currentRoute!);
      print(cost);
      _mapBlocFunctions!.orderChangesFunctions.currentOrder = Order(WaitingForOrderAcceptanceOrderStatus(),
          from: fromAddress!,
          to: toAddress!,
          wishes:
              _wishesController.text.isNotEmpty ? _wishesController.text : null,
          distance:
              (currentRoute!.metadata.weight.distance.value! / 1000).prettify(),
          employerId: await GetUserId(_authRepo).call(),
          orderForAnother: _otherNameController.text.isNotEmpty &&
                  _otherNumberController.text.isNotEmpty
              ? OrderForAnother(
                  _otherNumberController.text, _otherNameController.text)
              : null,
          startTime: _orderStartTime ?? DateTime.now(),
          costInRub: cost);
      print(_mapBlocFunctions!.orderChangesFunctions.currentOrder);
      await CreateOrder(_orderRepo).call(_mapBlocFunctions!.orderChangesFunctions.currentOrder!).then((value) {
        _mapBlocFunctions!.orderChangesFunctions.currentOrderId = value;
        _mapBlocFunctions!.orderChangesFunctions.activeOrders.add(OrderWithId(_mapBlocFunctions!.orderChangesFunctions.currentOrder!, _mapBlocFunctions!.orderChangesFunctions.currentOrderId!));
        _mapBlocFunctions!.orderChangesFunctions. setOrderListeners();
        add(GoMapEvent(WaitingForOrderAcceptanceMapState()));
      });
    });

    on<RecheckOrderMapEvent>((event, emit) async {
      switch (_mapBlocFunctions!.orderChangesFunctions.currentOrder!.status) {
        case WaitingForOrderAcceptanceOrderStatus():
          add(GoMapEvent(WaitingForOrderAcceptanceMapState()));
        case CancelledOrderStatus():
          add(GoMapEvent(CancelledOrderMapState()));
          _mapBlocFunctions!.orderChangesFunctions.activeOrders.removeWhere((element) => element.id == _mapBlocFunctions!.orderChangesFunctions.currentOrderId!);
        case OrderCancelledByDriverOrderStatus():
          add(GoMapEvent(OrderCancelledByDriverMapState()));
        case OrderAcceptedOrderStatus():
          var diff = _mapBlocFunctions!.orderChangesFunctions.currentOrder!.startTime.difference(DateTime.now());
          if (diff.inHours >= 1) {
            _mapBlocFunctions!.orderChangesFunctions.goToAcceptedInFuture(
                _mapBlocFunctions!.orderChangesFunctions.currentOrder!, Duration(minutes: diff.inMinutes - 31),
                onRetry: const Duration(minutes: 15));
            add(GoMapEvent(CreateOrderMapState(message: 'Водитель принял вашу заявку, за 30 минут до назначенного времени вы вернётесь в окно ожидания водителя')));
          } else {
            _driver = await GetDriverById(_fbAuthRepo)
                .call(_mapBlocFunctions!.orderChangesFunctions.currentOrder!.driverId!) as Driver;
            add(GoMapEvent(OrderAcceptedMapState()));
          }
        case SuccessfullyCompletedOrderStatus():
          _mapBlocFunctions!.orderChangesFunctions.disposeOrderListener();
          _driver = null;
          add(GoMapEvent(OrderCompleteMapState()));
        case ActiveOrderStatus():
          add(GoMapEvent(ActiveOrderMapState()));
      }
    });

    on<OnPaymentTapMapEvent>((event, emit) async {
      switch (event.paymentUiModel.paymentType) {
        case PaymentTypes.promo:
          add(GoMapEvent(PromoCodeMapState()));
        case PaymentTypes.card:
          _currentPaymentModel = event.paymentUiModel;
          SetCurrentPaymentModel(_paymentRepo).call(event.paymentUiModel);
          add(GoMapEvent(CreateOrderMapState()));
        case PaymentTypes.bonus:
          add(GoMapEvent(CheckBonusesMapState()));
        case PaymentTypes.cardAdd:
          add(GoMapEvent(AddCardMapState()));
        case PaymentTypes.cash:
          _currentPaymentModel = event.paymentUiModel;
          SetCurrentPaymentModel(_paymentRepo).call(event.paymentUiModel);
          add(GoMapEvent(CreateOrderMapState()));
      }
    });

    on<UseBonusesMapEvent>((event, emit) {
      try {
        ActivateBonuses(_paymentRepo).call().then((value) => emit(
            CheckBonusesMapState(
                balance: _bonusesBalance,
                message: 'Вы активировали ваши бонусы')));
      } catch (_) {
        emit(CheckBonusesMapState(
          status: Status.Failed,
          exception: 'Ошибка, не получилось активировать бонусы',
          balance: _bonusesBalance,
        ));
      }
    });

    on<AddPreliminaryTimeMapEvent>((event, emit) {
      _orderIsPremilinary = event.preliminary;
      _orderStartTime = event.preliminaryTime;
    });

    on<CheckPromoMapEvent>((event, emit) async {
      String message = '';

      final promo =
          await ActivatePromo(_paymentRepo).call(_promoController.text);

      if (promo != null) {
        _activePromo = promo;
        message =
            'Промокод был активирован, скидка на следующую оплату по карте составляет ${_activePromo!.discount} %';
      } else {
        message = 'Промокод не существует, либо был активирован';
      }
      emit(PromoCodeMapState(controller: _promoController, message: message));
    });

    on<CancelSearchMapEvent>((event, emit) async {
      print(_mapBlocFunctions!.orderChangesFunctions.currentOrder);

      if (_mapBlocFunctions!.orderChangesFunctions.currentOrder!.status is WaitingForOrderAcceptanceOrderStatus) {
        DeleteOrderById(_orderRepo).call(_mapBlocFunctions!.orderChangesFunctions.currentOrderId!);
        _mapBlocFunctions!.orderChangesFunctions.activeOrders.removeLast();
        _mapBlocFunctions!.orderChangesFunctions.disposeOrderListener();
        add(GoMapEvent(CreateOrderMapState()));
      }
    });

    on<CancelOrderMapEvent>((event, emit) async {
      _mapBlocFunctions!.orderChangesFunctions.currentOrder = _mapBlocFunctions!.orderChangesFunctions.currentOrder!
          .copyWith(status: CancelledOrderStatus(), cancelReason: event.reason);
      await UpdateOrderById(_orderRepo).call(_mapBlocFunctions!.orderChangesFunctions.currentOrderId!, _mapBlocFunctions!.orderChangesFunctions.currentOrder!);
      final chatRepo = ChatRepositoryImpl();
      var chat = await FindChat(chatRepo).call(
          driverId: _mapBlocFunctions!.orderChangesFunctions.currentOrder!.driverId!,
          employerId: _mapBlocFunctions!.orderChangesFunctions.currentOrder!.employerId);
      if (chat != null) {
        DeleteChat(chatRepo).call(
            driverId: _mapBlocFunctions!.orderChangesFunctions.currentOrder!.driverId!,
            employerId: _mapBlocFunctions!.orderChangesFunctions.currentOrder!.employerId);
      }
      add(GoMapEvent(CreateOrderMapState()));
    });

    on<GetOtherFromContactsMapEvent>((event, emit) async {
      if (await FlutterContacts.requestPermission()) {
        List<Contact> contacts = await FlutterContacts.getContacts(
            withPhoto: true, withProperties: true);
        // ignore: use_build_context_synchronously
        showModalBottomSheet(
            context: event.context,
            builder: (context) => SelectContactBottomSheet(
                contacts: contacts,
                onSelect: (c) async {
                  await FlutterContacts.openExternalView(c.id);
                  Contact? contact = await FlutterContacts.getContact(c.id);
                  _otherNameController.text = contact!.displayName;
                  String number = contact.phones.length != 0
                      ? contact.phones.first.number
                      : '';
                  if (number[0] == '+') {
                    number = number.substring(1, number.length);
                  }
                  if (number.isNotEmpty) {
                    number = number.substring(1, number.length);
                  }
                  _otherNumberController.text = number;
                }));
      }
    });
    on<ChangeCostMapEvent>((event, emit) async {
      _mapBlocFunctions!.orderChangesFunctions.currentOrder = _mapBlocFunctions!.orderChangesFunctions.currentOrder!.copyWith(costInRub: event.changedCost);
      await UpdateOrderById(_orderRepo).call(_mapBlocFunctions!.orderChangesFunctions.currentOrderId!, _mapBlocFunctions!.orderChangesFunctions.currentOrder!);
      add(GoMapEvent(WaitingForOrderAcceptanceMapState()));
    });

    on<GoToChatMapEvent>((event, emit) async {
      final chatRepo = ChatRepositoryImpl();
      var chat = await FindChat(chatRepo).call(
          driverId: _mapBlocFunctions!.orderChangesFunctions.currentOrder!.driverId!,
          employerId: _mapBlocFunctions!.orderChangesFunctions.currentOrder!.employerId);
      chat ??= await CreateChat(chatRepo).call(
          driverId: _mapBlocFunctions!.orderChangesFunctions.currentOrder!.driverId!,
          employerId: _mapBlocFunctions!.orderChangesFunctions.currentOrder!.employerId);
      if (chat.id != null) {
        event.context
            .pushNamed(AppRoutes.chat, pathParameters: {'chatId': chat.id!});
      }
    });
  }
}
