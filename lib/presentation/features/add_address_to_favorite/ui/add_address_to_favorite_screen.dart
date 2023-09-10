import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/add_address_to_favorite/bloc/state.dart';

import '../../../utils/app_style_util.dart';
import '../../../utils/size_util.dart';
import '../../../widgets/app_elevated_button.dart';
import '../../../widgets/app_pop_button.dart';

class AddAddressToFavoriteScreen extends StatelessWidget {
  AddAddressToFavoriteScreen({Key? key}) : super(key: key);

  final _name = TextEditingController();
  final _address = TextEditingController();
  final _entrance = TextEditingController();
  final _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {


    return BlocBuilder<AddAddressToFavoriteBloc, AddAddressToFavoriteState>(
        builder: (context, state) {
          final bloc = context.read<AddAddressToFavoriteBloc>();
          final key = GlobalKey<FormState>();
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Form(
                    key: key,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: AppPopButton(context,
                              text: 'Добавить адресс',
                              color: Colors.black,
                              textStyle: AppStyle.black16),
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


                          }),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
