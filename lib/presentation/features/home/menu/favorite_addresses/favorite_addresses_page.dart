import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/favorite_addresses/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/favorite_addresses/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/favorite_addresses/bloc/state.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/widgets/address_card.dart';
import 'package:sober_driver_analog/presentation/widgets/app_elevated_button.dart';
import 'package:sober_driver_analog/presentation/widgets/app_pop_button.dart';

import '../../../../utils/app_color_util.dart';
import '../../../../utils/size_util.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class FavoriteAddressesPage extends StatelessWidget {
  const FavoriteAddressesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState()));
        return false;
      },
      child: BlocBuilder<FavoriteAddressesBloc, FavoriteAddressesState>(
          builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: AppPopButton(context,
                            text: 'Избранные адреса',
                            onTap: () => context
                                .read<MenuBloc>()
                                .add(GoMenuEvent(newState: InitialMenuState())),
                            color: Colors.black,
                            textStyle: AppStyle.black16),
                      ),
                      SizedBox(
                        height: size.height - 100,
                        width: size.width - 40,
                        child: state.favoriteAddresses.isEmpty
                            ? Center(
                                child: Text(
                                  'Нет адресов',
                                  style: AppStyle.black22
                                      .copyWith(color: AppColor.firstColor),
                                ),
                              )
                            : ListView.separated(
                                itemBuilder: (BuildContext context, int index) {
                                  return AddressCard(
                                      state.favoriteAddresses[index], (p0) {},
                                      width: size.width - 40);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemCount: state.favoriteAddresses.length,
                              ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: AppElevatedButton(
                        text: 'Добавить',
                        width: size.width - 70,
                        onTap: () => context
                            .read<FavoriteAddressesBloc>()
                            .add(GoToNewPageForAddNewAddressEvent(context))),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
