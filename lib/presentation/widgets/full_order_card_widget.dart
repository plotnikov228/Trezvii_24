import 'package:flutter/material.dart';
import 'package:sober_driver_analog/data/firebase/auth/repository.dart';
import 'package:sober_driver_analog/data/firebase/storage/repository.dart';
import 'package:sober_driver_analog/domain/firebase/auth/repository/repository.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/get_driver_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_status.dart';
import 'package:sober_driver_analog/domain/firebase/order/model/order_with_id.dart';
import 'package:sober_driver_analog/domain/firebase/storage/usecases/get_photo_by_id.dart';
import 'package:sober_driver_analog/extensions/date_time_extension.dart';
import 'package:sober_driver_analog/extensions/order_status_extension.dart';
import 'package:sober_driver_analog/presentation/app.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_operation_mode.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/adresses_buttons.dart';
import 'package:sober_driver_analog/presentation/widgets/user_photo_with_border.dart';

import '../../data/auth/repository/repository.dart';
import '../../data/firebase/auth/models/driver.dart';
import '../../domain/firebase/auth/models/user_model.dart';
import '../../domain/firebase/auth/usecases/get_user_by_id.dart';
import '../utils/size_util.dart';

class FullOrderCardWidget extends StatefulWidget {
  final OrderWithId order;
  final String? submissionTime;
  const FullOrderCardWidget({Key? key, required this.order, this.submissionTime}) : super(key: key);

  @override
  State<FullOrderCardWidget> createState() => _FullOrderCardWidgetState();
}

class _FullOrderCardWidgetState extends State<FullOrderCardWidget> {

   UserModel? user;
   String? photoUrl;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final repo = FirebaseAuthRepositoryImpl();
    final storageRepo = FirebaseStorageRepositoryImpl();
    final String? uid = AppOperationMode.driverMode() ? widget.order.order.employerId : widget.order.order.driverId;
    if(uid != null) {
      if (AppOperationMode.userMode()) {
        GetDriverById(repo).call(uid).then((value) {
          user = value;
          setState(() {});
        });
      } else if (AppOperationMode.driverMode()) {
        GetUserById(repo).call(uid).then((value) {
          user = value;
          setState(() {});
        });
      }


      GetPhotoById(storageRepo).call(uid).then((value) {
        setState(() {
          photoUrl = value;
          print('photo - $value');
        });

    });
   }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        width: size.width - 60,
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.firstColor, width: 1),
            borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding:
          const EdgeInsets.only(left: 18, right: 18, top: 14, bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '№${widget.order.id}\n${widget.order.order.startTime.formatDateTime()}',
                    style: AppStyle.black12.copyWith(fontWeight: FontWeight.w300),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: AddressesButtons(
                      from: widget.order.order.from,
                      to: widget.order.order.to,
                      width: 150,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 10),
                      child: Text(
                        widget.order.order.status.description(),
                        style: AppStyle.black14
                            .copyWith(fontWeight: FontWeight.bold),
                      )),
                  if(user != null)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          user!.name,
                          style: AppStyle.black14
                              .copyWith(fontWeight: FontWeight.bold),
                        )),
                  if(widget.order.order.status is WaitingForOrderAcceptanceOrderStatus && widget.submissionTime != null)
                    Text('Время подачи ~ $widget.submissionTime', style: AppStyle.black14,)
                ],
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        '~ ${widget.order.order.costInRub} р.',
                        style: AppStyle.black16,
                      )),
                  if(photoUrl != null)
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: userPhotoWithBorder(url: photoUrl))
                ],)
            ],
          ),
        ),
      ),
    );
  }
}



