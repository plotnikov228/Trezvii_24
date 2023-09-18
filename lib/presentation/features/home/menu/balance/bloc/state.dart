import 'package:sober_driver_analog/presentation/utils/status_enum.dart';

class BalanceState {
  final double balance;
  final Status status;

  BalanceState({this.balance = 0, this.status = Status.Success});
}