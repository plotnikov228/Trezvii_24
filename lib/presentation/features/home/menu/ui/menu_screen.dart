import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/presentation/features/home/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/ui/widgets/menu_chapter.dart';
import 'package:sober_driver_analog/presentation/widgets/user_photo_with_border.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/utils/app_style_util.dart';
import 'package:sober_driver_analog/presentation/utils/size_util.dart';

import '../../../../utils/app_images_util.dart';
import '../bloc/state.dart';
import 'widgets/menu_app_bar.dart';

class MenuScreen extends StatelessWidget {
  final MenuBloc bloc;
  final InitialMenuState state;

  const MenuScreen({Key? key, required this.bloc, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              menuAppBar(
                child: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      userPhotoWithBorder(
                        url: state.userUrl,),
                      SizedBox(
                        height: 100,
                        width: 140,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.userModel?.name ?? '',
                              style: AppStyle.black20
                                  .copyWith(color: Colors.white),
                              overflow: TextOverflow.visible,
                            ),
                            Container(
                              height: 36,
                              width: 90,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 36,
                                width: 90,
                                child: Wrap(
                                  children: [
                                    SvgPicture.asset(
                                      AppImages.giftCard,
                                      color: AppColor.firstColor,
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${state.bonuses}',
                                      style: AppStyle.black17,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          AppImages.pencil,
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          bloc.add(GoToProfileMenuEvent(context));
                        },
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: size.width - 60,
                  child: Wrap(
                    spacing: 30,
                    direction: Axis.vertical,
                    children: [
                      menuChapter(
                          title: 'История заказов',
                          prefixWidget: SvgPicture.asset(
                            AppImages.time,
                            width: 25,
                            height: 25,

                          ),
                      onTap: () => bloc.add(GoMenuEvent(newState: OrdersMenuState()))
                      ),
                      menuChapter(
                          title: 'Способ оплаты',
                          prefixWidget: SvgPicture.asset(context.read<HomeBloc>().paymentUiModel?.prefixWidgetAsset ?? AppImages.wallet,
                              width: 25, height: 25, color: AppColor.firstColor)),
                      menuChapter(
                          title: 'Избранные адреса',
                          onTap: () => bloc.add(GoMenuEvent(newState: FavoriteAddressesMenuState())),
                          prefixWidget: Icon(Icons.favorite,
                              size: 25, color: AppColor.firstColor)),
                      menuChapter(
                          title: 'О компании',
                          onTap: () => bloc.add(GoMenuEvent(newState: AboutCompanyMenuState())),

                          prefixWidget: Icon(
                            Icons.info,
                            size: 25,
                            color: AppColor.firstColor,
                          )),
                      menuChapter(
                          title: 'Тарифы',
                          onTap: () => bloc.add(GoMenuEvent(newState: AboutTariffsMenuState())),
                          prefixWidget: Icon(
                            Icons.star,
                            size: 25,
                            color: AppColor.firstColor,
                          )),
                      menuChapter(
                          title: 'Новости',
                          onTap: () => bloc.add(GoMenuEvent(newState: NewsMenuState())),
                          prefixWidget: SvgPicture.asset(AppImages.news,
                              width: 25, height: 25, color: AppColor.firstColor)),
                      menuChapter(
                          title: 'Обратная связь',
                          onTap: () => bloc.add(GoMenuEvent(newState: FeedbackMenuState())),
                          prefixWidget: SvgPicture.asset(AppImages.feedback,
                              width: 25, height: 25, color: AppColor.firstColor)),
                      menuChapter(
                          title: 'Настройки',
                          prefixWidget: Icon(
                            Icons.settings,
                            size: 25,
                            color: AppColor.firstColor,
                          )),
                      menuChapter(
                          title: 'О приложении',
                          prefixWidget: SvgPicture.asset(
                            AppImages.aboutApp,
                            width: 25,
                            height: 25,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Image.asset(
                AppImages.logo,
                height: 60,
                width: 60,
              ),
            ))
      ],
    );
  }
}
