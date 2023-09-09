import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/firebase/chat/models/chat_messages.dart';
import 'package:sober_driver_analog/extensions/date_time_extension.dart';
import 'package:sober_driver_analog/presentation/app.dart';
import 'package:sober_driver_analog/presentation/features/chat/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/chat/ui/widgets/tringular_clipper.dart';
import 'package:sober_driver_analog/presentation/utils/app_color_util.dart';

import '../../../../utils/app_style_util.dart';

class MessageItem extends StatelessWidget {
  final List<ChatMessages> messages;
  final int index;
  final ChatBloc bloc;

  const MessageItem({
    super.key,
    required this.messages,
    required this.index,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = messages[index].idFrom == bloc.yourId;
    return Column(
      children: [
        if (messages.asMap().containsKey(index - 1) &&
            DateTime.parse(messages[index - 1].timestamp)
                    .difference(DateTime.parse(messages[index].timestamp))
                    .inHours >
                4)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                DateTime.parse(messages[index].timestamp)
                    .formatDateTimeForMessageItem(),
                style: AppStyle.hintText16.copyWith(fontSize: 13),
              ),
            ),
          ),
        Padding(
          // add some padding
          padding: EdgeInsets.fromLTRB(
            isCurrentUser ? 64.0 : 16.0,
            4,
            isCurrentUser ? 16.0 : 64.0,
            4,
          ),
          child: Align(
            // align the child within the container
            alignment:
                isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              children: [
                DecoratedBox(
                  // chat bubble decoration
                  decoration: BoxDecoration(
                    color:
                        isCurrentUser ? AppColor.firstColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      messages[index].content,
                      style: AppStyle.black17.copyWith(
                          color: isCurrentUser ? Colors.white : Colors.black87),
                    ),
                  ),
                ),
                ClipPath(
                  clipper: TringularClipper(!isCurrentUser),
                  child: Container(
                    width: 20,
                    height: 20,
                    color:
                        isCurrentUser ? AppColor.firstColor : Colors.grey[200],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
