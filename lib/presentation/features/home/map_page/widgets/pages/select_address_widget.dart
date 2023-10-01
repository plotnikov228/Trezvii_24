import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/presentation/app.dart';
import 'package:sober_driver_analog/presentation/features/home/map_page/bloc/state/state.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/address_card.dart';
import 'package:sober_driver_analog/presentation/widgets/app_snack_bar.dart';
import 'package:sober_driver_analog/presentation/widgets/app_text_form_field.dart';
import 'package:sober_driver_analog/presentation/widgets/point_widget.dart';

import '../../../../../utils/app_color_util.dart';
import '../../../../../utils/app_images_util.dart';
import '../../../../../utils/size_util.dart';
import '../../bloc/bloc/bloc.dart';
import '../../bloc/event/event.dart';

class SelectAddressWidget extends StatefulWidget {
  final MapBloc bloc;
  final SelectAddressesMapState state;

  const SelectAddressWidget(
      {super.key, required this.bloc, required this.state});

  @override
  State<SelectAddressWidget> createState() => _SelectAddressWidgetState();
}

class _SelectAddressWidgetState extends State<SelectAddressWidget>{
  final double initialHeight = size.height - 100;
  double height = size.height - 100;
  final double initialEndHeight = 340;

  @override
  void initState() {
    height = initialHeight;
    lastChangedTextField = widget.state.autoFocusedIndex ?? 0;
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

  bool showContent = false;
  late Offset startPosition;
  late Offset updatedPosition;

  late int lastChangedTextField;

  @override
  Widget build(BuildContext context) {
    print(widget.state.addresses.isNotEmpty
        ? widget.state.addresses.length
        : widget.state.favoriteAddresses.length);
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
            widget.bloc.add(GoMapEvent(StartOrderMapState()));
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
            widget.bloc.add(GoMapEvent(StartOrderMapState()));
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
                              padding: const EdgeInsets.only(left: 35, right: 35),
                              child: Column(
                                children: [
                                  AppTextFormField(
                                      height: 45,
                                      widget.bloc.firstAddressController,
                                      hintText: 'Откуда?',
                                      width: size.width - 70, onChanged: (text) {
                                    lastChangedTextField = 0;
                                    widget.bloc
                                        .add(SearchAddressMapEvent(text, 0));
                                  },
                                      autoFocus:
                                          widget.state.autoFocusedIndex == 0,
                                      prefixWidget: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Center(
                                                child: PointWidget(
                                                    size: const Size(24, 24)))),
                                      ),
                                      suffixWidget: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              height = initialEndHeight;
                                              showContent = false;
                                            });
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 500), () async {
                                                  if(widget.bloc.currentAddress != null ) {
                                                    final curAddress = await widget.bloc.currentAddress;
                                                    if(curAddress != null) {
                                                      widget.bloc.add(
                                                        GetAddressMapEvent(
                                                            curAddress,
                                                            whichAddressShouldReplace:
                                                            0));
                                                    } else {
                                                      AppSnackBar.showSnackBar(context, content: 'Ваше текущее местоположение не было определено');
                                                    }
                                                  }
                                            });

                                          },
                                          child: SizedBox(
                                              width: 50,
                                              height: 45,
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Text(
                                                  'Текущее место',
                                                  overflow: TextOverflow.visible,
                                                  textAlign: TextAlign.center,
                                                  style: AppStyle.black10.copyWith(
                                                      color: AppColor.firstColor),
                                                ),
                                              )))),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: AppTextFormField(
                                        height: 45,
                                        widget.bloc.secondAddressController,
                                        hintText: 'Куда?',
                                        width: size.width - 70,
                                        onChanged: (text) {
                                      lastChangedTextField = 1;
                                      widget.bloc
                                          .add(SearchAddressMapEvent(text, 1));
                                    },
                                        autoFocus:
                                            widget.state.autoFocusedIndex == 1,
                                        prefixWidget: const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.location_pin,
                                            color: Colors.black87,
                                            size: 24,
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: SizedBox(
                                      height: size.height - 100 - 201,
                                      child: ListView.separated(
                                          itemCount:
                                              widget.state.addresses.isNotEmpty
                                                  ? widget.state.addresses.length
                                                  : widget.state.favoriteAddresses
                                                      .length,
                                          separatorBuilder: (_, __) {
                                            return const SizedBox(
                                              height: 20,
                                            );
                                          },
                                          itemBuilder: (context, index) {
                                            return AddressCard(
                                                widget.state.addresses.isNotEmpty
                                                    ? widget
                                                        .state.addresses[index]
                                                    : widget.state
                                                        .favoriteAddresses[index],
                                                (p0) {
                                              setState(() {
                                                height = initialEndHeight;
                                                showContent = false;
                                              });
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                widget.bloc.add(GetAddressMapEvent(
                                                    p0,
                                                    whichAddressShouldReplace:
                                                        lastChangedTextField));
                                              });
                                            }, width: size.width - 60);
                                          }),
                                    ),
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
