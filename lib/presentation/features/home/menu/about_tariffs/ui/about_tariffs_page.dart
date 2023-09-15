import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_tariffs/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/about_tariffs/bloc/state.dart';

import '../../../../../utils/app_color_util.dart';
import '../../../../../utils/app_style_util.dart';
import '../../../../../utils/size_util.dart';
import '../../../../../utils/status_enum.dart';
import '../../../../../widgets/app_pop_button.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';
import '../../bloc/state.dart';
import '../../ui/widgets/full_description_card.dart';

class AboutTariffsPage extends StatelessWidget {
  const AboutTariffsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState()));
        return false;
      },
      child: BlocBuilder<AboutTariffsBloc, AboutTariffsState>(
          builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: AppPopButton(context,
                      text: 'Тарифы',
                      onTap: () => context
                          .read<MenuBloc>()
                          .add(GoMenuEvent(newState: InitialMenuState())),
                      color: Colors.black,
                      textStyle: AppStyle.black16),
                ),
                SizedBox(
                  height: size.height - 100,
                  width: size.width - 60,
                  child: state.status == Status.Loading ? SizedBox(width: 50, height: 50, child: Center(
                    child: CircularProgressIndicator(color: AppColor.firstColor,),
                  ),) : state.tariffs.isEmpty
                      ? Center(
                          child: Text(
                            'Информация о тарифах в данный момент недоступна',
                            style: AppStyle.black16
                                .copyWith(color: AppColor.firstColor),
                          ),
                        )
                      : ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return FullDescriptionCard(
                              width: size.width - 40,
                              title: state.tariffs[index].name, content: state.tariffs[index].description, badgeLabel: state.tariffs[index].displayCost,);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 20,
                            );
                          },
                          itemCount: state.tariffs.length,
                        ),
                )
              ],
            ),
          ),
        );
      }),
    ));
  }
}
