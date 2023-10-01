import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/presentation/app.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/utils/app_operation_mode.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/address_card.dart';
import 'package:sober_driver_analog/presentation/widgets/app_text_form_field.dart';
import 'package:sober_driver_analog/presentation/widgets/order_card_for_driver.dart';
import 'package:sober_driver_analog/presentation/widgets/point_widget.dart';

import '../../../../../utils/app_color_util.dart';
import '../../../../../utils/app_images_util.dart';
import '../../../../../utils/size_util.dart';
import '../../bloc/bloc/bloc.dart';
import '../../bloc/event/event.dart';

class SelectOrderWidget extends StatefulWidget {
  final MapBloc bloc;
  final SelectOrderMapState state;

  const SelectOrderWidget({super.key, required this.bloc, required this.state});

  @override
  State<SelectOrderWidget> createState() => _SelectOrderWidgetState();
}

class _SelectOrderWidgetState extends State<SelectOrderWidget>{
  final double initialHeight = size.height - 100;
  double height = size.height - 100;
  final double initialEndHeight = AppOperationMode.userMode() ? 340 : size.height - 200;

  @override
  void initState() {
    height = initialHeight;
    Future.delayed(const Duration(milliseconds: 60), () {
      setState(() {
        showContent = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool showContent = false;
  late Offset startPosition;
  late Offset updatedPosition;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();
    print('o');
    return GestureDetector(
      onPanStart: (_) {
        startPosition = _.globalPosition;
      },
      onPanUpdate: (_) {
        setState(() {
          updatedPosition = Offset(0, startPosition.dy - _.globalPosition.dy);
          height = initialHeight + updatedPosition.dy;
        });
        if (height == initialEndHeight) {
          setState(() {
            showContent = false;
          });

          Future.delayed(const Duration(milliseconds: 500), () {
            bloc.add(GoMapEvent(StartOrderMapState()));
          });
        }
      },
      onPanEnd: (_) async {
        setState(() {
          if ((initialHeight - height).abs() > 60) {
            height = initialEndHeight;

            showContent = false;
          } else {
            height = initialHeight;
          }
        });

        if ((initialHeight - height).abs() > 60) {
          Future.delayed(const Duration(milliseconds: 500), () {
            print('a');
            bloc.add(GoMapEvent(StartOrderMapState()));
          });
        }
      },
      child: SafeArea(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 400),
          child: Container(
            height: height < initialEndHeight ? initialEndHeight : height,
            width: size.width,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                color: Colors.white),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 43),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: showContent ? 1 : 0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 35, right: 35),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 35),
                                    child: Center(
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(children: [
                                          const TextSpan(
                                              text:
                                                  'Доступные заказы из города ',
                                              style: AppStyle.black16),
                                          TextSpan(
                                              text: widget.state.locality,
                                              style: AppStyle.black16.copyWith(
                                                  color: AppColor.firstColor))
                                        ]),
                                      ),
                                    ),
                                  ),
                                  widget.state.orders == null
                                      ? Center(
                                          child: SizedBox(
                                            width: 45,
                                            height: 45,
                                            child: CircularProgressIndicator(
                                              color: AppColor.firstColor,
                                            ),
                                          ),
                                        )
                                      : StreamBuilder(
                                          stream: widget.state.orders,
                                          builder:
                                              (BuildContext context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 45,
                                                  height: 45,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: AppColor.firstColor,
                                                  ),
                                                ),
                                              );
                                            }
                                            if((snapshot.data?.length ?? 0) == 0) return Center(child: Text('Нету доступных заказов', style: AppStyle.black16.copyWith(color: AppColor.firstColor),),);
                                            return SizedBox(
                                              height: size.height - 100 - 201,
                                              child: ListView.builder(
                                                  itemCount:
                                                      snapshot.data?.length ??
                                                          0,
                                                  itemBuilder:
                                                      (context, index) {
                                                     return Padding(
                                                       padding: const EdgeInsets.symmetric(vertical: 10),
                                                       child: InkWell(
                                                           onTap: () {
                                                             setState(() {
                                                               height = initialEndHeight;
                                                               showContent = false;
                                                             });
                                                             Future.delayed(
                                                                 const Duration(
                                                                     milliseconds: 500), () {
                                                               bloc.add(SelectOrderMapEvent(snapshot.data![index]));
                                                             });
                                                           },
                                                           child: OrderCardForDriver(order:snapshot.data![index])),
                                                     );

                                                      }),
                                            );
                                          },
                                        )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 43,
                  width: size.width,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      alignment: Alignment.center,
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: AppColor.darkGray),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
