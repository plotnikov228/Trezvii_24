import 'package:flutter/material.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/initial_map/contents/initial_map_user_content.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_operation_mode.dart';

import '../../../../../../utils/app_images_util.dart';
import '../../../../../../utils/size_util.dart';
import '../../../../ui/widgets/address_button.dart';
import '../../../bloc/event/event.dart';
import 'contents/initial_map_driver_content.dart';

class InitialMapWidget extends StatefulWidget {
  final InitialMapState state;
  final MapBloc bloc;

  const InitialMapWidget({super.key, required this.state, required this.bloc});

  @override
  State<InitialMapWidget> createState() => _InitialMapWidgetState();
}

class _InitialMapWidgetState extends State<InitialMapWidget>
    with TickerProviderStateMixin {
  bool showContent = true;

  final double initialHeight = 160;
  double height = 160;
  final double initialEndHeight = size.height - 100;

  @override
  void initState() {
    height = initialHeight;
    super.initState();
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
            updatedPosition =
                Offset(0, startPosition.dy - _.globalPosition.dy);
            height = initialHeight + updatedPosition.dy;
          });
          if (height == initialEndHeight) {
            setState(() {
              showContent = false;
            });

            Future.delayed(const Duration(milliseconds: 500), () {
              widget.bloc
                  .add(GoMapEvent(SelectAddressesMapState()));
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
              widget.bloc
                  .add(GoMapEvent(SelectAddressesMapState()));
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
                    topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                color: Colors.white),
            child: Column(
              children: [

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
                    child: Padding(
                        padding: const EdgeInsets.only(left: 35, right: 12),
                        child: AppOperationMode.mode ==
                            AppOperationModeEnum.user ? InitialMapUserContent(
                          state: widget.state,
                          onAddressButtonTap: () {
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
                          }, onArrowTap: () {
                          setState(() {
                            height = 313;
                          });
                          setState(() {
                            showContent = false;
                          });

                          Future.delayed(
                              const Duration(milliseconds: 500),
                                  () {
                                widget.bloc.add(GoMapEvent(
                                    StartOrderMapState()));
                              });
                        }, onFavoriteAddressButtonTap: () {
                          height = initialEndHeight;

                          setState(() {
                            showContent = false;
                          });

                          Future.delayed(
                              const Duration(milliseconds: 500),
                                  () {
                                widget.bloc.add(GoMapEvent(
                                    SelectAddressesMapState()));
                              });
                        },
                        ) : InitialMapDriverContent(
                          onMainButtonTap: () {
                            height = initialEndHeight;
                            setState(() {
                              showContent = false;
                            });
                            Future.delayed(
                                const Duration(milliseconds: 500),
                                    () {
                                  widget.bloc.add(GoMapEvent(
                                      SelectOrderMapState()));
                                });
                          },
                        )
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
