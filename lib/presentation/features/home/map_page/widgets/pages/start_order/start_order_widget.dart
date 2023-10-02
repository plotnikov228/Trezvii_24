import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/presentation/features/auth/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/driver_state.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/user_state.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/map_bottom_bar.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/start_order/contents/start_order_driver_content.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/widgets/pages/start_order/contents/start_order_user_content.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/widgets/map/location_button.dart';
import '../../../../../../utils/size_util.dart';
import '../../../bloc/event/event.dart';

class StartOrderWidget extends StatefulWidget {
  final StartOrderMapState state;
  final MapBloc bloc;

  const StartOrderWidget({super.key, required this.state, required this.bloc});

  @override
  State<StartOrderWidget> createState() => _StartOrderWidgetState();
}

class _StartOrderWidgetState extends State<StartOrderWidget>{
  bool showContent = false;

  final double initialHeight = 340 ;
  double height = 340;
  final double initialEndHeight = size.height - 100;

  @override
  void initState() {
    super.initState();
    height = initialHeight;
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        showContent = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  late Offset startPosition;
  late Offset updatedPosition;

  @override
  Widget build(BuildContext context) {
    print('a');
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: showContent ? 1 : 0,
            child: Align(alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: LocationButton(onTap: () => widget.bloc.add(GoToCurrentPositionMapEvent())),
            ),),
          ),

          GestureDetector(
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
              if(height <= 160) {
                height = 160;
              }
              else if ((initialHeight - height).abs() > 100) {
                height = initialEndHeight;

                showContent = false;

                Future.delayed(const Duration(milliseconds: 500), () {
                  widget.bloc.add(GoMapEvent(SelectAddressesMapState()));
                });
              } else {
                height = initialHeight;
              }setState(() {

              });
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
                        child: StartOrderUserContent(state: widget.state as StartOrderUserMapState, onToTap: () {
                          height = initialEndHeight;
                          setState(() {
                            showContent = false;
                          });
                          Future.delayed(const Duration(milliseconds: 500), () {
                            widget.bloc.add(
                                GoMapEvent(SelectAddressesMapState(autoFocusedIndex: 1)));
                          });
                        },
                        onFromTap:  () {
                          height = initialEndHeight;

                          setState(() {
                            showContent = false;
                          });

                          Future.delayed(const Duration(milliseconds: 500), () {
                            widget.bloc.add(
                                GoMapEvent(SelectAddressesMapState(autoFocusedIndex: 0)));
                          });
                        },
                        )
                  )]),
            ),
          ),
          ),
        ],
      )
    );
  }
}
