import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/data/db/repository/repository.dart';
import 'package:sober_driver_analog/data/firebase/chat/repository.dart';
import 'package:sober_driver_analog/data/firebase/firestore/repository.dart';
import 'package:sober_driver_analog/data/firebase/order/repository.dart';
import 'package:sober_driver_analog/data/firebase/storage/repository.dart';
import 'package:sober_driver_analog/data/map/repository/repository.dart';
import 'package:sober_driver_analog/data/payment/repository/repository.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/get_driver_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/get_user_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/chat/usecases/create_chat.dart';
import 'package:sober_driver_analog/domain/firebase/chat/usecases/find_chat.dart';
import 'package:sober_driver_analog/domain/firebase/firestore/usecases/get_collection_data.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_status.dart';
import 'package:sober_driver_analog/domain/firebase/order/usecases/delete_order_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/order/usecases/update_order_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/storage/usecases/get_photo_by_id.dart';
import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:sober_driver_analog/domain/map/usecases/get_routes.dart';
import 'package:sober_driver_analog/domain/payment/enums/payment_types.dart';
import 'package:sober_driver_analog/domain/payment/models/payment_ui_model.dart';
import 'package:sober_driver_analog/domain/payment/usecases/activate_bonuses.dart';
import 'package:sober_driver_analog/domain/payment/usecases/activate_promo.dart';
import 'package:sober_driver_analog/domain/payment/usecases/set_current_payment_ui_model.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/functions.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/driver_state.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/select_contact_bottom_sheet.dart';
import 'package:sober_driver_analog/presentation/routes/routes.dart';
import 'package:sober_driver_analog/presentation/utils/app_operation_mode.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../../../../../../data/auth/repository/repository.dart';
import '../../../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../../../data/firebase/auth/repository.dart';
import '../../../../../../../domain/firebase/order/model/order_with_id.dart';
import '../../../../../../../domain/map/models/address_model.dart';
import '../../../../../../domain/db/constants.dart';
import '../../../../../../domain/db/usecases/db_query.dart';
import '../../../../../../domain/firebase/auth/models/user_model.dart';
import '../../../../../../domain/payment/models/tariff.dart';
import '../../../../../utils/status_enum.dart';
import '../state/state.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../event/event.dart';
import '../state/user_state.dart';

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

  Future<AddressModel?>? get currentAddress =>
      _mapBlocFunctions?.mapFunctions.getCurrentAddress();

  CameraPosition? _cameraPosition;

  CameraPosition? get cameraPosition => _cameraPosition;

  void setGetAddressFromMap(bool _) => _getAddressFromMap = _;

  void setCameraPosition(CameraPosition _) => _cameraPosition = _;

  Stream<DrivingRoute>? get routeStream =>
      _mapBlocFunctions!.mapFunctions.positionStream;

  final mapCompleter = Completer<YandexMapController>();

  bool get orderInCompanyRange {
    bool createOrder = true;
    if (fromAddress != null && toAddress != null) {
      bool fromContains = _mapBlocFunctions!.addressesFunctions.localities
          .map((e) => e.toLowerCase())
          .contains(fromAddress!.locality?.toLowerCase());
      bool toContains = _mapBlocFunctions!.addressesFunctions.localities
          .map((e) => e.toLowerCase())
          .contains(toAddress!.locality?.toLowerCase());
      print('$fromContains $toContains');
      if (!fromContains && !toContains) {
        createOrder = false;
      }
    }
    return createOrder;
  }

  String get localities =>
      _mapBlocFunctions!.addressesFunctions.localities.join(', ');

  final _paymentRepo = PaymentRepositoryImpl();
  final _orderRepo = OrderRepositoryImpl();
  final _mapRepo = MapRepositoryImpl();
  final _fbAuthRepo = FirebaseAuthRepositoryImpl();
  final _authRepo = AuthRepositoryImpl();
  final _dbRepo = DBRepositoryImpl();
  MapBlocFunctions? _mapBlocFunctions;

  PaymentUiModel get currentPaymentModel =>
      _mapBlocFunctions!.paymentsFunctions.currentPaymentModel;

  UserModel? _user;
  String? _userPhotoUrl;

  List<OrderWithId> get activeOrders =>
      _mapBlocFunctions?.orderFunctions.activeOrders ?? [];

  AddressModel? fromAddress;
  AddressModel? toAddress;

  MapState? previousState;
  MapState? currentState;

  DrivingRoute? currentRoute;

  Driver? _driver;

  Driver? get driver => _driver;

  void setDriver(Driver? _) => _driver = _;

  List<Tariff> _tariffs = [];
  int _currentTariffIndex = 0;

  MapBloc(super.initialState) {
    bool isUser = AppOperationMode.userMode();
    _mapBlocFunctions = MapBlocFunctions(this);
    on<InitMapBloc>((event, emit) async {
      if (isUser) {
        await _mapBlocFunctions!.userInit();
      } else {
        await _mapBlocFunctions!.driverInit();
      }
    });

    on<GoToCurrentPositionMapEvent>((event, emit) async {
      final lastPos =
          await _mapBlocFunctions?.mapFunctions.getCurrentPosition();
      if (lastPos != null) {
        mapCompleter.future.then((value) => value.moveCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
                target: lastPos.toPoint(), zoom: cameraPosition?.zoom ?? 15)),
            animation: const MapAnimation(duration: 0.5)));
      }
    });

    on<GoMapEvent>((event, emit) async {
      if (event.newState is! CancelledOrderMapState) {
        if (currentState != null &&
            currentState.toString() != event.newState.toString()) {
          previousState = currentState;
        }
        currentState = event.newState;
      }
      if (event.newState is InitialMapState) {
        emit(InitialMapState(
            lastFavoriteAddress:
                _mapBlocFunctions!.addressesFunctions.lastFavoriteAddress));
      }
      if (event.newState is SelectOrderMapState) {
        emit(SelectOrderMapState(
            locality: _mapBlocFunctions!.orderFunctions.locality ?? '',
            orders: _mapBlocFunctions!.orderFunctions.availableOrders()));
      }
      if (event.newState is SelectAddressesMapState) {
        event.newState as SelectAddressesMapState;
        final _favoriteAddresses =
            (await DBQuery(_dbRepo).call(DBConstants.favoriteAddressesTable))
                .map((e) => AddressModel.fromDB(e))
                .toList();
        emit(SelectAddressesMapState(
          status: event.newState.status,
          autoFocusedIndex:
              (event.newState as SelectAddressesMapState).autoFocusedIndex,
          addresses: (event.newState as SelectAddressesMapState).addresses,
          favoriteAddresses: _favoriteAddresses,
        ));
      }
      if (event.newState is StartOrderMapState) {
        if (isUser) {
          if (_tariffs.isEmpty) {
            _tariffs =
                (await GetCollectionData(FirebaseFirestoreRepositoryImpl())
                        .call('Tariffs'))
                    .map((e) => Tariff.fromJson(e))
                    .toList();
          }

          if (event.newState is StartOrderUserMapState &&
              (event.newState as StartOrderUserMapState).currentIndexTariff !=
                  _currentTariffIndex) {
            _currentTariffIndex =
                (event.newState as StartOrderUserMapState).currentIndexTariff;
          }
          emit(StartOrderUserMapState(
              canCreateOrder: orderInCompanyRange,
              status: event.newState.status,
              currentPaymentUiModel:
                  _mapBlocFunctions!.paymentsFunctions.currentPaymentModel,
              currentIndexTariff: _currentTariffIndex,
              tariffList: _tariffs,
              exception: event.newState.exception,
              message: event.newState.message));
        } else {
          emit(StartOrderDriverMapState(
            userModel: _user,
            exception: event.newState.exception,
            message: event.newState.message,
            photoUrl: _userPhotoUrl,
            orderWithId: _mapBlocFunctions!.orderFunctions.currentOrder != null
                ? OrderWithId(_mapBlocFunctions!.orderFunctions.currentOrder!,
                    _mapBlocFunctions!.orderFunctions.currentOrderId!)
                : null,
            status: event.newState.status,
          ));
        }
      }
      if (event.newState is SelectPaymentMethodMapState) {
        emit(SelectPaymentMethodMapState(
          status: event.newState.status,
          methods: _mapBlocFunctions!.paymentsFunctions.methodsList,
        ));
      }
      if (event.newState is WaitingForOrderAcceptanceMapState) {
        emit(WaitingForOrderAcceptanceMapState());
      }
      if (event.newState is CancelledOrderMapState) {
        emit(CancelledOrderMapState(
          orderId: (event.newState as CancelledOrderMapState).orderId,
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
            status: event.newState.status,
            orderId: (event.newState as OrderCompleteMapState).orderId ?? _mapBlocFunctions!.orderFunctions.currentOrderId,
            id: (event.newState as OrderCompleteMapState).id ??
                (AppOperationMode.userMode()
                    ? _mapBlocFunctions!.orderFunctions.currentOrder!.driverId
                    : _mapBlocFunctions!
                        .orderFunctions.currentOrder!.employerId)));
      }
      if (event.newState is OrderCancelledByDriverMapState) {
        emit(OrderCancelledByDriverMapState(
            status: event.newState.status, driver: _driver));
      }
      if (event.newState is OrderAcceptedMapState) {
        final driverPosition =
            (await GetDriverById(_fbAuthRepo).call(_driver!.userId) as Driver)
                .currentPosition;
        final route = (await GetRoutes(_mapRepo).call([
          driverPosition ?? const MoscowLocation(),
          fromAddress!.appLatLong
        ]))!
            .first;
        print(route.metadata.weight.timeWithTraffic.value! ~/ 60);
        emit(OrderAcceptedMapState(
            status: event.newState.status,
            distance: route.metadata.weight.distance.text,
            driver: _driver,
            waitingTime: _mapBlocFunctions!.orderFunctions.orderIsPreliminary
                ? _mapBlocFunctions!.orderFunctions.currentOrder!.startTime
                    .difference(DateTime.now())
                : _driver!.currentPosition != null
                    ? Duration(
                        minutes:
                            route.metadata.weight.timeWithTraffic.value! ~/ 60)
                    : const Duration(minutes: 15)));
      }
      if (event.newState is CheckBonusesMapState) {
        emit(CheckBonusesMapState(
            status: event.newState.status,
            balance: _mapBlocFunctions!.paymentsFunctions.bonusesBalance));
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
        for (var item in _mapBlocFunctions!.orderFunctions.activeOrders) {
          final driver = (await GetDriverById(_fbAuthRepo)
              .call(item.order.driverId ?? ''));
          drivers.add(driver as Driver?);
        }
        emit(ActiveOrdersMapState(
            status: event.newState.status,
            orders: _mapBlocFunctions!.orderFunctions.activeOrders,
            users: drivers as List<Driver?>,
            currentOrder: _mapBlocFunctions!.orderFunctions.currentOrder));
      }
      if (event.newState is AddPriceMapState) {
        emit(AddPriceMapState(
            order: _mapBlocFunctions!.orderFunctions.currentOrder));
      }
    });

    on<SelectOrderMapEvent>((event, emit) async {
      _mapBlocFunctions!.orderFunctions.currentOrderId = event.order.id;
      _mapBlocFunctions!.orderFunctions.currentOrder = event.order.order;
      fromAddress = _mapBlocFunctions!.orderFunctions.currentOrder!.from;
      toAddress = _mapBlocFunctions!.orderFunctions.currentOrder!.to;
      final route = (await GetRoutes(_mapRepo).call([fromAddress!.appLatLong, toAddress!.appLatLong]))?.first;
      if(route != null) {
        currentRoute = route;
      }
      _user = await GetUserById(_fbAuthRepo)
          .call(_mapBlocFunctions!.orderFunctions.currentOrder!.employerId);
      _userPhotoUrl = await GetPhotoById(FirebaseStorageRepositoryImpl())
          .call(_mapBlocFunctions!.orderFunctions.currentOrder!.employerId);
      add(GoMapEvent(StartOrderMapState()));
    });

    on<SearchAddressMapEvent>((event, emit) async {
      add(GoMapEvent(SelectAddressesMapState(
          addresses: await _mapBlocFunctions!.addressesFunctions
              .searchAddresses(event.address, _cameraPosition!))));
    });

    on<GetAddressMapEvent>((event, emit) async {
      if (event.whichAddressShouldReplace == 0) {
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

      add(GoMapEvent(StartOrderMapState()));
    });

    on<ProceedOrderMapEvent>((event, emit) async {
      _mapBlocFunctions!.orderFunctions.proceedOrder();
    });

    on<CreateOrderMapEvent>((event, emit) async {
      add(GoMapEvent(StartOrderMapState(status: Status.Loading)));
      await _mapBlocFunctions!.orderFunctions.createOrder(
          _tariffs[_currentTariffIndex],
          wishes: _wishesController.text,
          otherName: _otherNameController.text,
          otherNumber: _otherNumberController.text);
    });

    on<RecheckOrderMapEvent>((event, emit) async {
      await _mapBlocFunctions!.orderFunctions.recheckOrderStatus();
    });

    on<OnPaymentTapMapEvent>((event, emit) async {
      switch (event.paymentUiModel.paymentType) {
        case PaymentTypes.promo:
          add(GoMapEvent(PromoCodeMapState()));
        case PaymentTypes.card:
          _mapBlocFunctions!.paymentsFunctions
              .setPaymentModel(event.paymentUiModel);
          SetCurrentPaymentModel(_paymentRepo).call(event.paymentUiModel);
          add(GoMapEvent(StartOrderMapState()));
        case PaymentTypes.bonus:
          add(GoMapEvent(CheckBonusesMapState()));
        case PaymentTypes.cardAdd:
          add(GoMapEvent(AddCardMapState()));
        case PaymentTypes.cash:
          _mapBlocFunctions!.paymentsFunctions
              .setPaymentModel(event.paymentUiModel);
          SetCurrentPaymentModel(_paymentRepo).call(event.paymentUiModel);
          add(GoMapEvent(StartOrderMapState()));
      }
    });

    on<UseBonusesMapEvent>((event, emit) {
      try {
        ActivateBonuses(_paymentRepo).call().then((value) => emit(
            CheckBonusesMapState(
                balance: _mapBlocFunctions!.paymentsFunctions.bonusesBalance,
                message: 'Вы активировали ваши бонусы')));
      } catch (_) {
        emit(CheckBonusesMapState(
          status: Status.Failed,
          exception: 'Ошибка, не получилось активировать бонусы',
          balance: _mapBlocFunctions!.paymentsFunctions.bonusesBalance,
        ));
      }
    });

    on<AddPreliminaryTimeMapEvent>((event, emit) {
      _mapBlocFunctions!.orderFunctions.setPreliminary(event.preliminary);
      _mapBlocFunctions!.orderFunctions.setStartTime(event.preliminaryTime);
    });

    on<CheckPromoMapEvent>((event, emit) async {
      String message = '';

      final promo =
          await ActivatePromo(_paymentRepo).call(_promoController.text);

      if (promo != null) {
        _mapBlocFunctions!.paymentsFunctions.activePromo = promo;
        message =
            'Промокод был активирован, скидка на следующую оплату по карте составляет ${_mapBlocFunctions!.paymentsFunctions.activePromo!.discount} %';
      } else {
        message = 'Промокод не существует, либо был активирован';
      }
      emit(PromoCodeMapState(controller: _promoController, message: message));
    });

    on<CancelSearchMapEvent>((event, emit) async {
      print(_mapBlocFunctions!.orderFunctions.currentOrder);
      await _mapBlocFunctions!.orderFunctions.cancelSearch(id: event.id);
    });

    on<CancelOrderMapEvent>((event, emit) async {
      await _mapBlocFunctions!.orderFunctions
          .cancelCurrentOrder(event.id, event.reason);
      add(RecheckOrderMapEvent());
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
      _mapBlocFunctions!.orderFunctions.currentOrder = _mapBlocFunctions!
          .orderFunctions.currentOrder!
          .copyWith(costInRub: event.changedCost);
      await UpdateOrderById(_orderRepo).call(
          _mapBlocFunctions!.orderFunctions.currentOrderId!,
          _mapBlocFunctions!.orderFunctions.currentOrder!);
      add(GoMapEvent(WaitingForOrderAcceptanceMapState()));
    });

    on<GoToChatMapEvent>((event, emit) async {
      final chatRepo = ChatRepositoryImpl();
      var chat = await FindChat(chatRepo).call(
          driverId: _mapBlocFunctions!.orderFunctions.currentOrder!.driverId!,
          employerId:
              _mapBlocFunctions!.orderFunctions.currentOrder!.employerId);
      chat ??= await CreateChat(chatRepo).call(
          driverId: _mapBlocFunctions!.orderFunctions.currentOrder!.driverId!,
          employerId:
              _mapBlocFunctions!.orderFunctions.currentOrder!.employerId);
      if (chat.id != null) {
        event.context
            .pushNamed(AppRoutes.chat, pathParameters: {'chatId': chat.id!});
      }
    });

    on<CompleteOrderMapEvent>((event, emit) async {
      _mapBlocFunctions!.orderFunctions
          .completeOrder(rating: event.rating, uid: event.id!);
    });
  }
}
