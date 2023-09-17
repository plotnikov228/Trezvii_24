import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sober_driver_analog/presentation/features/chat/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/chat/bloc/state.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';
import 'package:sober_driver_analog/presentation/widgets/app_text_form_field.dart';

import '../../../../utils/app_images_util.dart';
import '../../../../utils/size_util.dart';
import '../../bloc/event.dart';

class ChatBottomBar extends StatelessWidget {
  final ChatState state;
  final ChatBloc bloc;
  const ChatBottomBar({super.key, required this.state, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(width: 1, color: AppColor.lightGray))
      ),
      margin: EdgeInsets.only(top: 10,left: 10, right: 10),
      child: Row(
        children: [AppTextFormField(state.controller!, textInputAction: TextInputAction.newline, width: size.width - 75),
        SizedBox(width: 10,),
        IconButton(
          visualDensity: VisualDensity.compact,
          iconSize: 30,
          icon: SvgPicture.asset(AppImages.send,
          color: AppColor.firstColor,), onPressed: () {
            bloc.add(SendMessageChatEvent());
        },
        )
        ],
      ),
    );
  }
}
