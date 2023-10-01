import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/search_bottom_sheet/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/search_bottom_sheet/bloc/state.dart';
import 'package:sober_driver_analog/presentation/widgets/app_text_form_field.dart';

import '../../../utils/app_color_util.dart';
import '../../../utils/app_style_util.dart';
import '../../../utils/size_util.dart';
import '../../../widgets/address_card.dart';
import 'bloc/event.dart';

class SearchBottomSheet extends StatelessWidget {
  final TextEditingController controller;

  const SearchBottomSheet(
      {Key? key,
      required this.controller,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBottomSheetBloc>(create: (_) => SearchBottomSheetBloc(SearchBottomSheetState()),
    child: BlocBuilder<SearchBottomSheetBloc, SearchBottomSheetState>(
        builder: (BuildContext context, SearchBottomSheetState state) {
          final bloc = context.read<SearchBottomSheetBloc>();
          return Container(
            height: size.height - 160,
            width: size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: AppTextFormField(controller, width: size.width - 40,
                        hintText: 'Адресс',
                        onChanged: (text) {
                          bloc.add(SearchAddressByTextEvent(text));
                        }),
                  ),
                  LimitedBox(
                    maxHeight: size.height - 160,
                    child: state.addresses.isEmpty ? Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Text('Введите адресс', style: AppStyle.black22
                          .copyWith(color: AppColor.firstColor),),
                      ),) :  ListView.separated(
                      itemCount: state.addresses.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AddressCard(state.addresses[index], (address) {
                              controller.text = address.addressName;
                              context.pop(address);
                            }, width: size.width - 40),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },

      ),
    );
  }
}
