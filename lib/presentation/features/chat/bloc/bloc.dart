import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/data/auth/repository/repository.dart';
import 'package:sober_driver_analog/data/firebase/auth/models/driver.dart';
import 'package:sober_driver_analog/data/firebase/auth/repository.dart';
import 'package:sober_driver_analog/domain/auth/usecases/get_user_id.dart';
import 'package:sober_driver_analog/domain/firebase/auth/repository/repository.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/get_driver_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/auth/usecases/get_user_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/chat/models/chat_messages.dart';
import 'package:sober_driver_analog/domain/firebase/chat/usecases/find_chat_by_id.dart';
import 'package:sober_driver_analog/domain/firebase/chat/usecases/send_message_to_chat.dart';
import 'package:sober_driver_analog/presentation/features/chat/bloc/event.dart';
import 'package:sober_driver_analog/presentation/features/chat/bloc/state.dart';

import '../../../../data/firebase/chat/repository.dart';
import '../../../../domain/firebase/auth/models/user_model.dart';
import '../../../../domain/firebase/chat/models/chat.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  Chat? _chat;
  late final String yourId;
  String? talkerPhotoUrl;
  late UserModel? talker;
  final _repo = ChatRepositoryImpl();

  final String chatId;

  ChatBloc(super.initialState, this.chatId) {
    on<LoadChatEvent>((event, emit) async {

      yourId = await GetUserId(AuthRepositoryImpl()).call();
      final chat = await FindChatById(_repo).call(id: event.chatId);
      if (chat == null) {
        emit(ChatState(status: ChatStateStatus.chatDoesNotExist));
      } else {

          talker = (await GetDriverById(FirebaseAuthRepositoryImpl()).call(chat!.driverId));
          try {
            talkerPhotoUrl =
            await FirebaseStorage.instance.ref('${talker?.userId}/photo')
                .getDownloadURL();
          } catch (_) {
            talkerPhotoUrl =
                (talker as Driver?)?.personalDataOfTheDriver?.driverPhotoUrl;
          }

        _chat = chat;
        emit(ChatState(
          scrollController: _scrollController,
            status: ChatStateStatus.success,
            chat: _chat!,
            controller: _controller));
      }
    });

    on<SendMessageChatEvent>((event, emit) async {
      if (_controller.text.trim().isNotEmpty) {
        await SendMessageToChat(_repo).call(
            message: ChatMessages(
                idFrom: _chat!.employerId,
                idTo: _chat!.driverId,
                timestamp: DateTime.now().toIso8601String(),
                content: _controller.text.trim()),
            chatId: chatId);
        _controller.text = '';
      }
    });
  }
}
