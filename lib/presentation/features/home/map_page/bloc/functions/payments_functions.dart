import 'package:sober_driver_analog/data/auth/repository/repository.dart';
import 'package:sober_driver_analog/data/payment/repository/repository.dart';
import 'package:sober_driver_analog/domain/auth/usecases/get_user_id.dart';
import 'package:sober_driver_analog/domain/firebase/penalties/model/penalty.dart';
import 'package:sober_driver_analog/domain/firebase/penalties/repository.dart';
import 'package:sober_driver_analog/domain/firebase/penalties/usecases/add_penalty.dart';
import 'package:sober_driver_analog/domain/firebase/penalties/usecases/delete_penalty.dart';
import 'package:sober_driver_analog/domain/firebase/penalties/usecases/get_penalties.dart';
import 'package:sober_driver_analog/domain/payment/models/card.dart';
import 'package:sober_driver_analog/domain/payment/usecases/add_card.dart';
import 'package:sober_driver_analog/domain/payment/usecases/get_penalty_cost.dart';
import 'package:sober_driver_analog/domain/payment/usecases/payment_of_the_penalty.dart';

import '../../../../../../data/firebase/penalties/repository.dart';
import '../../../../../../domain/payment/models/payment_ui_model.dart';
import '../../../../../../domain/payment/models/promo_code.dart';
import '../../../../../../domain/payment/usecases/check_bonuses_for_activity.dart';
import '../../../../../../domain/payment/usecases/check_promo_for_activity.dart';
import '../../../../../../domain/payment/usecases/get_bonuses_balance.dart';
import '../../../../../../domain/payment/usecases/get_cards.dart';
import '../../../../../../domain/payment/usecases/get_current_payment_models.dart';
import '../../../../../../domain/payment/usecases/get_current_payment_ui_model.dart';
import '../../../../../utils/status_enum.dart';
import '../bloc/bloc.dart';

class PaymentsFunctions {
  final MapBloc bloc;
  PaymentsFunctions(this.bloc);

  PromoCode? activePromo;
  late int bonusesBalance;
  bool bonusesSpend = false;
  late PaymentUiModel _currentPaymentModel;

  PaymentUiModel get currentPaymentModel => _currentPaymentModel;
  void setPaymentModel (PaymentUiModel _) => _currentPaymentModel = _;
  late List<PaymentUiModel> methodsList;

  final _paymentRepo = PaymentRepositoryImpl();
  final _penaltyRepo = PenaltyRepositoryImpl();
  late final List<UserCard> _cards;
  List<UserCard> get cards => _cards;
  List<Penalty> _penalties = [];
  List<Penalty> get penalties => _penalties;

  Future init () async {
    activePromo = await CheckPromoForActivity(_paymentRepo).call();
    bonusesBalance = await GetBonusesBalance(_paymentRepo).call();
    bonusesSpend =
        await CheckBonusesForActivity(_paymentRepo).call() != null;
    _currentPaymentModel = await GetCurrentPaymentModel(_paymentRepo).call();
    _cards = await GetCards(_paymentRepo).call();
    methodsList = GetCurrentPaymentModels(_paymentRepo).call(true, cards: _cards);
    _penalties = await GetPenalties(_penaltyRepo).call();
    print(_penalties);
  }

  Future addCard(UserCard card) async {
    await AddCard(_paymentRepo).call(card);
    _cards.add(card);
  }

  Future paymentOfThePenalty ({Penalty? penalty, UserCard? card}) async {
    final wasPayed = await PaymentOfThePenalty(_paymentRepo).call(penalty: penalty, card: card);
    if(!wasPayed && !_penalties.contains(penalty)) {
      _penalties.add(penalty ?? Penalty(dateTime: DateTime.now(), userId: await GetUserId(AuthRepositoryImpl()).call(), cost: await GetPenaltyCost(_paymentRepo).call()));
      AddPenalty(_penaltyRepo).call(penalty ?? Penalty(dateTime: DateTime.now(), userId: await GetUserId(AuthRepositoryImpl()).call(), cost: await GetPenaltyCost(_paymentRepo).call()));
    } else if(!wasPayed) {
      bloc.emit(bloc.state.copyWith(status: Status.Failed, exception: 'Оплата не прошла'));
    } else if(penalty != null && (await GetPenalties(_penaltyRepo).call()).contains(penalty)) {
      await DeletePenalty(_penaltyRepo).call(penalty);
      _penalties.remove(penalty);
      bloc.emit(bloc.state.copyWith(status: Status.Success, message: 'Штраф был оплачен'));
    }
  }
}