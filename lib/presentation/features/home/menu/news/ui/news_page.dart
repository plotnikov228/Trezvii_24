import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/news/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/news/bloc/state.dart';


import '../../../../../utils/app_color_util.dart';
import '../../../../../utils/app_style_util.dart';
import '../../../../../utils/size_util.dart';
import '../../../../../utils/status_enum.dart';
import '../../../../../widgets/app_pop_button.dart';
import '../../bloc/bloc.dart';
import '../../bloc/event.dart';
import '../../bloc/state.dart';
import '../../ui/widgets/full_description_card.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        context.read<MenuBloc>().add(GoMenuEvent(newState: InitialMenuState()));
        return false;
      },
      child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: AppPopButton(context,
                      text: 'Новости',
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
                  ),) : state.news.isEmpty
                      ? Center(
                          child: Text(
                            'Нету новостей',
                            style: AppStyle.black16
                                .copyWith(color: AppColor.firstColor),
                          ),
                        )
                      : ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return FullDescriptionCard(width: size.width - 40,title: state.news[index].title, content: state.news[index].content, badgeLabel: state.news[index].date,);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 20,
                            );
                          },
                          itemCount: state.news.length,
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
