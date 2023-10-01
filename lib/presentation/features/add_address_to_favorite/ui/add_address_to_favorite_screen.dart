import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:sober_driver_analog/domain/map/models/address_model.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/search_bottom_sheet/search_bottom_sheet.dart';
import 'package:sober_driver_analog/presentation/widgets/app_snack_bar.dart';
import 'package:sober_driver_analog/presentation/widgets/app_text_form_field.dart';

import '../../../utils/app_style_util.dart';
import '../../../utils/size_util.dart';
import '../../../widgets/app_elevated_button.dart';
import '../../../widgets/app_pop_button.dart';
import '../../home/menu/favorite_addresses/bloc/event.dart';

class AddAddressToFavoriteScreen extends StatelessWidget {
  AddAddressToFavoriteScreen({Key? key}) : super(key: key);

  final _name = TextEditingController();
  final _address = TextEditingController();
  final _entrance = TextEditingController();
  final _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:BlocBuilder<AddAddressToFavoriteBloc, AddAddressToFavoriteState>(
        builder: (context, state) {
          final bloc = context.read<AddAddressToFavoriteBloc>();
          return  SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: AppPopButton(context,
                              text: 'Добавить адресс',
                              color: Colors.black,
                              textStyle: AppStyle.black16),
                        ),
                        Padding(padding: const EdgeInsets.only(top: 20),
                          child: AppTextFormField(_name, width: size.width - 40,
                            hintText: 'Название',
                            textInputAction: TextInputAction.next,
                          ),

                        ),
                        Padding(padding: const EdgeInsets.only(top: 20),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet<AddressModel?>(
                                  isScrollControlled: true,
                                  barrierColor: Colors.grey.withOpacity(0.3),
                                  elevation: 5,
                                  context: context,
                                  builder: (_) =>
                                      SearchBottomSheet(controller: _address,)).then((value) {
                                        if(value != null) bloc.add(SelectAddressEvent(value));
                              });
                            },
                            child: IgnorePointer(
                              child: AppTextFormField(
                                  _address, width: size.width - 40,
                                  hintText: 'Адрес',
                                  textInputAction: TextInputAction.next
                              ),
                            ),
                          ),

                        ),
                        Padding(padding: const EdgeInsets.only(top: 20),
                          child: AppTextFormField(_entrance, width: size.width -
                              40,
                              hintText: 'Подъезд',
                              textInputAction: TextInputAction.next
                          ),

                        ),
                        Padding(padding: const EdgeInsets.only(top: 20),
                          child: AppTextFormField(_comment, width: size.width -
                              40,
                              hintText: 'Комментарий',
                              height: 140,
                              textInputAction: TextInputAction.newline
                          ),

                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: AppElevatedButton(
                          text: 'Сохранить',
                          width: size.width - 70,
                          onTap: () {
                            if (bloc.addressModel != null) {
                              bloc.add(ConfirmAddAddressEvent(context, name: _name.text,
                                  addressName: _address.text,
                                  entrance: _entrance.text,
                                  locality: bloc.addressModel!.locality,
                                  comment: _comment.text));
                            } else {
                              bloc.add(CheckAddressForExistence(
                                  _address.text, context, name: _name.text,
                                  addressName: _address.text,
                                  entrance: _entrance.text,
                                  comment: _comment.text));
                            }
                          }),
                    ),
                  )
                ],
              ),
            );

        }));
  }
}
