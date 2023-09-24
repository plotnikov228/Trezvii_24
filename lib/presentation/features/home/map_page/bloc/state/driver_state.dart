import 'package:sober_driver_analog/domain/firebase/auth/models/user_model.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';

import '../../../../../../domain/firebase/order/model/order_with_id.dart';

class StartOrderDriverMapState extends StartOrderMapState {
  final OrderWithId? orderWithId;
  final UserModel? userModel;
  final String? photoUrl;

  StartOrderDriverMapState({this.orderWithId, this.userModel, this.photoUrl, super.message, super.exception, super.status});
}