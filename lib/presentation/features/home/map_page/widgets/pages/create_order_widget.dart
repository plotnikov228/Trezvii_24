import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/presentation/features/auth/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/map_bottom_bar.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';
import 'package:sober_driver_analog/presentation/widgets/app_snack_bar.dart';

import '../../../../../utils/app_images_util.dart';
import '../../../../../utils/app_style_util.dart';
import '../../../../../utils/size_util.dart';
import '../../../../../widgets/adresses_buttons.dart';
import '../../../../../widgets/point_widget.dart';
import '../../../../../widgets/tariff_card.dart';
import '../../../ui/widgets/address_button.dart';
import '../../bloc/event/event.dart';

class CreateOrderWidget extends StatefulWidget {
  final CreateOrderMapState state;
  final MapBloc bloc;

  const CreateOrderWidget({super.key, required this.state, required this.bloc});

  @override
  State<CreateOrderWidget> createState() => _CreateOrderWidgetState();
}

class _CreateOrderWidgetState extends State<CreateOrderWidget>
    with TickerProviderStateMixin {
  bool showContent = true;

  final double initialHeight = 313;
  double height = 313;
  final double initialEndHeight = size.height - 100;

  @override
  void initState() {
    height = initialHeight;
  }

  @override
  void dispose() {
    super.dispose();
  }

  late Offset startPosition;
  late Offset updatedPosition;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
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
              widget.bloc.add(GoMapEvent(SelectAddressesMapState()));
            });
          }
        },
        onPanEnd: (_) async {
          setState(() {
            if ((initialHeight - height).abs() > 100) {
              height = initialEndHeight;

              showContent = false;
            } else {
              height = initialHeight;
            }
          });

          if ((initialHeight - height).abs() > 100) {
            Future.delayed(const Duration(milliseconds: 500), () {
              widget.bloc.add(GoMapEvent(SelectAddressesMapState()));
            });
          }
        },
        child: AnimatedSize(
          duration: const Duration(milliseconds: 400),
          child: Container(
              height: height < initialHeight ? initialHeight : height,
              width: size.width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                  color: Colors.white),
              child: Column(children: [
                SizedBox(
                  height: 43,
                  width: size.width,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: AppColor.darkGray),
                    ),
                  ),
                ),
                AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: showContent ? 1 : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child:  AddressesButtons(from: widget.bloc.fromAddress, to: widget.bloc.toAddress, onFromTap: () {
                            height = initialEndHeight;

                            setState(() {
                              showContent = false;
                            });

                            Future.delayed(
                                const Duration(milliseconds: 500),
                                    () {
                                  widget.bloc.add(GoMapEvent(
                                      SelectAddressesMapState(
                                          autoFocusedIndex: 0)));
                                });
                          }, onToTap: () {
                            height = initialEndHeight;
                            setState(() {
                              showContent = false;
                            });
                            Future.delayed(
                                const Duration(milliseconds: 500),
                                    () {
                                  widget.bloc.add(GoMapEvent(
                                      SelectAddressesMapState(
                                          autoFocusedIndex: 1)));
                                });
                          },)

                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 31, bottom: 11),
                            child: SizedBox(
                              height: 62,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.state.tariffList!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: index == 0 ? 35 : 10,
                                      ),
                                      child: TariffCard(null,
                                         tariff: widget.state.tariffList![index],
                                          selected: index ==
                                              widget.state.currentIndexTariff,
                                          onTap: () => widget.bloc.add(
                                              GoMapEvent(
                                                  CreateOrderMapState(
                                                      currentIndexTariff:
                                                          index)))),
                                    );
                                  }),
                            )),
                        MapBottomBar(bloc: widget.bloc, onMainButtonTap: () {
                          if(widget.bloc.fromAddress == null || widget.bloc.toAddress == null) {
                            AppSnackBar.showSnackBar(context, content: 'Выберите маршрут поездки');
                          } else {
                            widget.bloc.add(CreateOrderMapEvent());
                          }
                        }, onPaymentMethodTap: () => widget.bloc.add(GoMapEvent(SelectPaymentMethodMapState())),
                        onWishesTap: () => widget.bloc.add(GoMapEvent(AddWishesMapState()))
                        )
                      ],
                    ))
              ])),
        ),
      ),
    );
  }
}
