import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sober_driver_analog/data/firebase/chat/repository.dart';
import 'package:sober_driver_analog/domain/firebase/chat/models/chat.dart';
import 'package:sober_driver_analog/domain/firebase/chat/models/chat_messages.dart';
import 'package:sober_driver_analog/presentation/features/chat/bloc/bloc.dart';
import 'package:sober_driver_analog/presentation/features/chat/bloc/state.dart';
import 'package:sober_driver_analog/presentation/features/chat/ui/widgets/message_item.dart';

import '../../../../../domain/firebase/chat/usecases/get_chat_messages.dart';
import '../../../../utils/app_color_util.dart';

Widget buildListMessage({required ChatState state, required ChatBloc bloc}) {
  return Flexible(
    child: bloc.chatId.isNotEmpty
        ? StreamBuilder<List<ChatMessages>>(
        stream: GetChatMessages(ChatRepositoryImpl()).call(chatId: bloc.chatId, limit: 20),
        builder: (BuildContext context,
            AsyncSnapshot<List<ChatMessages>> snapshot) {
          final listMessages = snapshot.data!;
          if (snapshot.hasData) {
            if (listMessages.isNotEmpty) {
              return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: listMessages.length,
                  reverse: true,
                  controller: state.scrollController,
                  itemBuilder: (context, index) =>
                      MessageItem(messages: listMessages, index: index, bloc: bloc,));
            } else {
              return const Center(
                child: Text('No messages...'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: AppColor.firstColor,
              ),
            );
          }
        })
        : Center(
      child: CircularProgressIndicator(
        color: AppColor.firstColor,
      ),
    ),
  );
}