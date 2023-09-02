import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sober_driver_analog/data/db/repository/repository.dart';
import 'package:sober_driver_analog/data/firebase/order/repository.dart';
import 'package:sober_driver_analog/data/map/repository/repository.dart';
import 'package:sober_driver_analog/data/payment/repository/repository.dart';
import 'package:sober_driver_analog/domain/auth/usecases/get_user_id.dart';
import 'package:sober_driver_analog/domain/db/usecases/db_query.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/get_driver_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/get_user_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_for_another.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_status.dart';
import 'package:sober_driver_analog/domain/firebase/order/usecases/create_order.dart';
import 'package:sober_driver_analog/domain/firebase/order/usecases/remove_changes_order_listener.dart';
import 'package:sober_driver_analog/domain/firebase/order/usecases/set_changes_order_listener.dart';
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
import 'package:sober_driver_analog/extensions/point_extension.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../../../../../../data/auth/repository/repository.dart';
import '../../../../../../../data/firebase/auth/models/driver.dart';
import '../../../../../../../data/firebase/auth/repository.dart';
import '../../../../../../../domain/firebase/order/usecases/get_your_orders.dart';
import '../../../../../../../domain/map/models/address_model.dart';
import '../../../../../../../domain/map/usecases/get_duration_between_two_points.dart';
import '../../../../../../../domain/payment/enums/payment_types.dart';
import '../../../../../../../domain/payment/models/payment_ui_model.dart';
import '../../../../../../../domain/payment/models/promo_code.dart';
import '../../../../../../../domain/tutorial/models/tariff_model.dart';
import '../../../../../../utils/app_color_util.dart';
import '../../../../../../utils/app_images_util.dart';
import '../../../../../../utils/status_enum.dart';
import '../state/state.dart';

import '../event/event.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final firstAddressController = TextEditingController();
  final secondAddressController = TextEditingController();
  final favoriteAddressController = TextEditingController();
  final _promoController = TextEditingController();
  final _otherNameController = TextEditingController();
  final _otherNumberController = TextEditingController();
  final _otherReasonForCancelOrderController = TextEditingController();
  final _wishesController = TextEditingController();
  bool _getAddressFromMap = true;

  bool get getAddressFromMap => _getAddressFromMap;

  PolylineMapObject? _polylineMapObject;

  PolylineMapObject? get polylineMapObject => _polylineMapObject;

  PlacemarkMapObject? _firstPoint;

  PlacemarkMapObject? get firstPoint => _firstPoint;

  PlacemarkMapObject? _secondPoint;

  PlacemarkMapObject? get secondPoint => _secondPoint;

  CameraPosition? _cameraPosition;

  CameraPosition? get cameraPosition => _cameraPosition;

  void setGetAddressFromMap(bool _) => _getAddressFromMap = _;

  void setPolylineMapObject(PolylineMapObject _) => _polylineMapObject = _;

  void setFirstPoint(PlacemarkMapObject _) => _firstPoint = _;

  void setSecondPoint(PlacemarkMapObject _) => _secondPoint = _;

  void setCameraPosition(CameraPosition _) => _cameraPosition = _;

  final _paymentRepo = PaymentRepositoryImpl();
  final _orderRepo = OrderRepositoryImpl();
  final _mapRepo = MapRepositoryImpl();
  final _fbAuthRepo = FirebaseAuthRepositoryImpl();
  final _authRepo = AuthRepositoryImpl();

  AddressModel? fromAddress;
  AddressModel? toAddress;

  MapState? previousState;
  MapState? currentState;

  DrivingRoute? _currentRoute;

  Order? _currentOrder;
  String? _currentOrderId;

  final _orderStateChanges = StreamController<Order>();
  StreamSubscription? _orderStateChangesListener;

  PromoCode? _activePromo;
  late int _bonusesBalance;
  bool _bonusesSpend = false;

  DateTime? _orderStartTime;
  bool _orderIsPremilinary = false;

  late PaymentUiModel _currentPaymentModel;

  PaymentUiModel get currentPaymentModel => _currentPaymentModel;
  late List<PaymentUiModel> _methodsList;

  Driver? _driver;

  late final List<Order> activeOrders;

  void setOrderListeners() {
    _orderStateChangesListener = _orderStateChanges.stream.listen((event) {
      if (_currentOrder!.status != event.status) {
        _currentOrder = event;
        add(RecheckOrderMapEvent());
      }
    });
    SetChangesOrderListener(_orderRepo)
        .call((p0) => _orderStateChanges.add(p0!), _currentOrderId!);
  }

  MapBloc(super.initialState) {
    int currentTariffIndex = 0;

    on<InitMapBloc>((event, emit) async {
      _activePromo = await CheckPromoForActivity(_paymentRepo).call();
      _bonusesBalance = await GetBonusesBalance(_paymentRepo).call();
      _bonusesSpend =
          await CheckBonusesForActivity(_paymentRepo).call() != null;
      _currentPaymentModel = await GetCurrentPaymentModel(_paymentRepo).call();
      _methodsList = GetCurrentPaymentModels(_paymentRepo).call(true);
      activeOrders = (await GetYourOrders(_orderRepo).call())
          .where((element) =>
              element.status != OrderCancelledByDriverOrderStatus() &&
              element.status != CancelledOrderStatus() &&
              element.status != SuccessfullyCompletedOrderStatus())
          .toList();
      if (activeOrders.isNotEmpty) {
        _currentOrder = activeOrders.first;
        setOrderListeners();
        if (activeOrders.first.driverId != null) {
          _driver = await GetDriverById(_fbAuthRepo)
              .call(activeOrders.first.driverId!) as Driver?;
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
        emit(InitialMapState());
      }
      if (event.newState is SelectAddressesMapState) {
        event.newState as SelectAddressesMapState;
        print((event.newState as SelectAddressesMapState)
            .addresses
            .map((e) => e.addressName)
            .toList());
        emit(SelectAddressesMapState(
          autoFocusedIndex:
              (event.newState as SelectAddressesMapState).autoFocusedIndex,
          addresses: (event.newState as SelectAddressesMapState).addresses,
          favoriteAddresses:
              (event.newState as SelectAddressesMapState).favoriteAddresses,
        ));
      }
      if (event.newState is CreateOrderMapState) {
        if ((event.newState as CreateOrderMapState).currentIndexTariff !=
            currentTariffIndex) {
          currentTariffIndex =
              (event.newState as CreateOrderMapState).currentIndexTariff;
        }
        emit(CreateOrderMapState(
          currentPaymentUiModel: _currentPaymentModel,
          currentIndexTariff: currentTariffIndex,
          tariffList: [
            TariffModel('Трезвый водитель', 1999),
            TariffModel('Личный водитель', 6999)
          ],
        ));
      }
      if (event.newState is SelectPaymentMethodMapState) {
        emit(SelectPaymentMethodMapState(
          methods: _methodsList,
        ));
      }
      if (event.newState is WaitingForOrderAcceptanceMapState) {
        emit(WaitingForOrderAcceptanceMapState());
      }
      if (event.newState is CancelledOrderMapState) {
        emit(CancelledOrderMapState(
          otherReason: _otherReasonForCancelOrderController,
          reasons: [
            'Уже нет необходимости в поездке',
            'Недостаточно денег',
            'Другая причина:'
          ],
        ));
      }
      if (event.newState is ActiveOrderMapState) {
        emit(ActiveOrderMapState());
      }
      if (event.newState is OrderCompleteMapState) {
        emit(OrderCompleteMapState(driver: _driver));
      }
      if (event.newState is OrderCancelledByDriverMapState) {
        emit(OrderCancelledByDriverMapState(driver: _driver));
      }
      if (event.newState is OrderAcceptedMapState) {
        emit(OrderAcceptedMapState(
            driver: _driver,
            waitingTime: await GetDurationBetweenTwoPoints(_mapRepo)
                .call(fromAddress!.appLatLong, _driver!.currentPosition!)));
      }
      if (event.newState is CheckBonusesMapState) {
        emit(CheckBonusesMapState(balance: _bonusesBalance));
      }
      if (event.newState is PromoCodeMapState) {
        emit(PromoCodeMapState(controller: _promoController));
      }
      if (event.newState is AddCardMapState) {
        emit(AddCardMapState());
      }
      if (event.newState is AddWishesMapState) {
        emit(AddWishesMapState(
            wish: _wishesController,
            otherName: _otherNameController,
            otherNumber: _otherNumberController));
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
        setFirstPoint(PlacemarkMapObject(
            mapId: const MapObjectId('1'),
            point: fromAddress!.appLatLong.toPoint(),
            icon: PlacemarkIcon.composite([
              PlacemarkCompositeIconItem(
                  style: PlacemarkIconStyle(
                      image: BitmapDescriptor.fromAssetImage(
                          AppImages.startPoint)),
                  name: '')
            ])));
      } else {
        toAddress = event.selectedAddress;
        secondAddressController.text = fromAddress!.addressName;
        setSecondPoint(PlacemarkMapObject(
            mapId: const MapObjectId('2'),
            point: toAddress!.appLatLong.toPoint(),
            icon: PlacemarkIcon.composite([
              PlacemarkCompositeIconItem(
                  style: PlacemarkIconStyle(
                      image:
                          BitmapDescriptor.fromAssetImage(AppImages.geoMark)),
                  name: '')
            ])));
      }
      if (fromAddress != null && toAddress != null) {
        _currentRoute = (await GetRoutes(_mapRepo)
                .call([fromAddress!.appLatLong, toAddress!.appLatLong]))!
            .first;
        setPolylineMapObject(PolylineMapObject(
          mapId: const MapObjectId('0'),
          polyline: Polyline(
            points: _currentRoute!.geometry,
          ),
          strokeWidth: 3,
          strokeColor: AppColor.routeColor,
        ));
      }
      setCameraPosition(
          CameraPosition(target: event.selectedAddress!.appLatLong.toPoint()));

      add(GoMapEvent(CreateOrderMapState()));
    });

    on<CreateOrderMapEvent>((event, emit) async {
      _currentOrder = Order(WaitingForTheDriverOrderStatus(),
          from: fromAddress!,
          to: toAddress!,
          wishes:
              _wishesController.text.isNotEmpty ? _wishesController.text : null,
          distance: _currentRoute!.metadata.weight.distance.value!,
          employerId: await GetUserId(_authRepo).call(),
          orderForAnother: _otherNameController.text.isNotEmpty &&
                  _otherNumberController.text.isNotEmpty
              ? OrderForAnother(
                  _otherNumberController.text, _otherNameController.text)
              : null,
          startTime: _orderStartTime ?? DateTime.now(),
          costInRub: await GetCostInRub(_mapRepo).call(
              _currentRoute!.geometry.map((e) => e.toAppLatLong()).toList()));
      _currentOrderId = await CreateOrder(_orderRepo).call(_currentOrder!);
      setOrderListeners();
      add(GoMapEvent(WaitingForOrderAcceptanceMapState()));
    });

    on<RecheckOrderMapEvent>((event, emit) async {
      switch (_currentOrder!.status) {
        case WaitingForTheDriverOrderStatus():
          add(GoMapEvent(WaitingForOrderAcceptanceMapState()));
        case CancelledOrderStatus():
          add(GoMapEvent(CancelledOrderMapState()));
        case OrderCancelledByDriverOrderStatus():
          add(GoMapEvent(OrderCancelledByDriverMapState()));
        case OrderAcceptedOrderStatus():
          _driver = await GetDriverById(_fbAuthRepo)
              .call(_currentOrder!.driverId!) as Driver;
          add(GoMapEvent(OrderAcceptedMapState()));
        case SuccessfullyCompletedOrderStatus():
          _orderStateChangesListener!.cancel();
          RemoveChangesOrderListener(_orderRepo).call();
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
          message = 'Промокод был активирован, скидка на следующую оплату по карте составляет ${_activePromo!.discount} %';
        } else {
          message = 'Промокод не существует, либо был активирован';


        }
      emit(PromoCodeMapState(controller: _promoController, message: message));

    });
  }
}
