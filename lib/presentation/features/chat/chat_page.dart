import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/presentation/features/chat/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/chat/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/chat/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/chat/ui/widgets/build_list_messages.dart';
import 'package:sober_driver_analog/presentation/features/chat/ui/widgets/chat_app_bar.dart';

import '../../utils/status_enum.dart';
import '../../widgets/app_progress_container.dart';
import 'ui/widgets/chat_bottom_bar.dart';

class ChatPage extends StatelessWidget {
  final String chatId;

  const ChatPage({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ChatBloc>(
        create: (BuildContext context) =>
            ChatBloc(ChatState(status: ChatStateStatus.pageLoading), chatId)
              ..add(LoadChatEvent(chatId)),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (BuildContext context, state) {
            final bloc = context.read<ChatBloc>();
            if (state.status == ChatStateStatus.pageLoading) {
              return Center(
                child: AppProgressContainer(),
              );
            }

            return Stack(
              children: [
                buildListMessage(state: state, bloc: bloc),
                Align(
                    alignment: Alignment.topCenter,
                    child: ChatAppBar(
                      userModel: bloc.talker,
                      bloc: bloc,
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ChatBottomBar(
                    bloc: bloc,
                    state: state,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
