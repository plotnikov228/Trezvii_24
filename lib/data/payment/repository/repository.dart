import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sober_driver_analog/data/auth/repository/repository.dart';
import 'package:sober_driver_analog/data/db/repository/repository.dart';
import 'package:sober_driver_analog/data/firebase/auth/repository.dart';
import 'package:sober_driver_analog/data/firebase/firestore/repository.dart';
import 'package:sober_driver_analog/domain/auth/usecases/get_user_id.dart';
import 'package:sober_driver_analog/domain/db/usecases/db_query.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/get_user_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/update_user.dart';
import 'package:sober_driver_analog/domain/firebase/firestore/usecases/get_collection_data.dart';
import 'package:sober_driver_analog/domain/payment/models/payment_ui_model.dart';
import 'package:sober_driver_analog/domain/payment/models/promo_code.dart';
import 'package:sober_driver_analog/domain/payment/models/tariff.dart';
import 'package:sober_driver_analog/presentation/utils/app_images_util.dart';

import '../../../domain/payment/enums/payment_types.dart';
import '../../../domain/payment/models/card.dart';
import '../../../domain/payment/repository/repostitory.dart';
import '../../../presentation/utils/app_color_util.dart';
import '../../firebase/auth/models/user.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class PaymentRepositoryImpl extends PaymentRepository {
  final _promo = 'Promo';

  final _promoPrefsKey = 'currentPromo';
  final _bonusesPrefsKey = 'spendBonuses';
  final _bonusesBalancePrefsKey = 'bonusesBalanse';

  final _fbAuthRepo = FirebaseAuthRepositoryImpl();

  @override
  List<PaymentUiModel> getCurrentPaymentUiModels(bool functionalOn,
      {Function? onPromoTap,
      Function? onBonusTap,
      Function? onCashTap,
      Function? onCardTap,
      List<UserCard> cards = const []}) {
    final listPaymentUiModels = [
      PaymentUiModel(
          onTap: onPromoTap,
          paymentType: PaymentTypes.promo,
          prefixWidgetAsset: AppImages.discount,
          title: 'Промокод',
          suffixWidget: Image.asset(AppImages.rightArrow,
              width: 25, height: 25, color: AppColor.firstColor)),
      PaymentUiModel(
          onTap: onBonusTap,
          paymentType: PaymentTypes.bonus,
          prefixWidgetAsset: AppImages.giftCard,
          title: 'Бонусы',
          suffixWidget: Image.asset(AppImages.rightArrow,
              width: 25, height: 25, color: AppColor.firstColor)),
      PaymentUiModel(
          onTap: onCashTap,
          paymentType: PaymentTypes.cash,
          prefixWidgetAsset: AppImages.wallet,
          title: 'Наличные',
          suffixWidget: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
                color: AppColor.firstColor, shape: BoxShape.circle),
          )),
      PaymentUiModel(
          onTap: onCardTap,
          paymentType: PaymentTypes.cardAdd,
          prefixWidgetAsset: AppImages.card,
          title: 'Добавить карту',
          suffixWidget: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
                color: AppColor.firstColor, shape: BoxShape.circle),
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 15,
              ),
            ),
          )),
    ];
    if (cards.isNotEmpty) {
      for (var item in cards) {
        listPaymentUiModels.insert(
          3,
          PaymentUiModel(
              onTap: onCardTap,
              paymentType: PaymentTypes.card,
              card: item,
              prefixWidgetAsset: AppImages.card,
              title:
                  '${item.number.substring(0, 4)} **** **** ${item.number.substring(12, item.number.length)}',
              suffixWidget: Image.asset(AppImages.rightArrow,
                  color: AppColor.firstColor, width: 25, height: 25)),
        );
      }
    }
    return listPaymentUiModels;
  }

  @override
  Future<PromoCode?> activatePromo(String promo) async {
    final doc = FirebaseFirestore.instance.collection(_promo).doc(promo);
    final data = await doc.get();
    if ((data).exists) {
      final promocode = PromoCode.fromJson(data.data()!);
      if (!promocode.activatedUsers
          .contains(await GetUserId(AuthRepositoryImpl()).call())) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(_promoPrefsKey, promocode.promo);
        return promocode;
      }
    }
  }

  @override
  Future setActivatedPromo(PromoCode promoCode) async {
    final doc =
        FirebaseFirestore.instance.collection(_promo).doc(promoCode.promo);
    final data = await doc.get();
    if ((data).exists) {
      final promoFromFB = PromoCode.fromJson(data.data()!)
        ..activatedUsers.add(
            (await DBQuery(DBRepositoryImpl()).call('user')).first['userId']);

      doc.update(promoFromFB.toJson());
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_promoPrefsKey, '');
    }
  }

  @override
  Future activateBonuses() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_bonusesPrefsKey, true);
  }

  @override
  Future<int> addBonusesToBalance(int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final balance = prefs.getInt(_bonusesBalancePrefsKey) ?? 0;
    final newBalance = balance + quantity;
    prefs.setInt(_bonusesBalancePrefsKey, newBalance);
    await UpdateUser(_fbAuthRepo).call(bonuses: newBalance);
    return newBalance;
  }

  @override
  Future<String> cardPay(UserCard card) async {
    // some func
    return '';
  }

  @override
  Future<int?> checkBonusesForActivity() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_bonusesPrefsKey) ?? false) {
      return prefs.getInt(_bonusesBalancePrefsKey);
    }
  }

  @override
  Future<PromoCode?> checkPromoForActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final promo = prefs.getString(_promoPrefsKey) ?? '';
    if (promo.isNotEmpty) {
      final doc = FirebaseFirestore.instance.collection(_promo).doc(promo);
      final data = await doc.get();
      if (data.exists) {
        return PromoCode.fromJson(data.data()!);
      }
    }
  }

  @override
  Future<int> getBonusesBalance() async {
    final prefs = await SharedPreferences.getInstance();
    late final int bonusesOnDb;
    int balance = prefs.getInt(_bonusesBalancePrefsKey) ?? 0;

    try {
      bonusesOnDb = (await GetUserById(_fbAuthRepo)
              .call(auth.FirebaseAuth.instance.currentUser!.uid) as User)
          .bonuses;
    } catch (_) {
      bonusesOnDb = balance;
    }
    if (bonusesOnDb != balance) {
      balance = bonusesOnDb;
      await prefs.setInt(_bonusesBalancePrefsKey, balance);
    }
    return balance;
  }

  @override
  Future spendBonuses() async {
    // some func
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_bonusesBalancePrefsKey, 0);
    await UpdateUser(_fbAuthRepo).call(bonuses: 0);
  }

  @override
  Future<PaymentUiModel> getCurrentPaymentUiModel() async {
    final prefs = await SharedPreferences.getInstance();
    final list = getCurrentPaymentUiModels(false);

    final currentPaymentMethod =
        prefs.getString('currentPaymentMethod') ?? list[2].title;
    PaymentUiModel? value;
    for (var item in list) {
      if (currentPaymentMethod == item.title) {
        value = item;
      }
    }
    return value ?? list[2];
  }

  @override
  Future<PaymentUiModel> setCurrentPaymentUiModel(
      PaymentUiModel newPaymentUiModel) async {
    final prefs = await SharedPreferences.getInstance();
    final currentPaymentMethod =
        prefs.setString('currentPaymentMethod', newPaymentUiModel.title);
    final list = getCurrentPaymentUiModels(false);
    PaymentUiModel? value;
    for (var item in list) {
      if (currentPaymentMethod == item.title) {
        value = item;
      }
    }
    return value ?? list[2];
  }

  final _repo = FirebaseFirestoreRepositoryImpl();

  @override
  Future<double> getCosts(Tariff tariff,
      {bool getHourPrice = false,
      getKmPrice = false,
      bool getStartPrice = false,
      bool getPriceOfFirstHours = false}) async {
    final remoteConfig = FirebaseRemoteConfig.instance
      ..setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 14),
          minimumFetchInterval: const Duration(seconds: 5)));
    await remoteConfig.fetch();
    await remoteConfig.activate();
    if (getStartPrice) {
      print('${tariff.startPriceKey} 1');
      return remoteConfig.getDouble(tariff.startPriceKey ?? '');
    }
    if (getHourPrice) {
      print('${tariff.hourPriceKey} 2');

      return remoteConfig.getDouble(tariff.hourPriceKey ?? '');
    }
    if (getKmPrice) {
      print('${tariff.kmPriceKey} 3');

      return remoteConfig.getDouble(tariff.kmPriceKey ?? '');
    }
    if (getPriceOfFirstHours) {
      print('${tariff.theCostOfFirstHoursKey} 4');
      return remoteConfig.getDouble(tariff.theCostOfFirstHoursKey ?? '');
    }
    return 0;
  }
}
