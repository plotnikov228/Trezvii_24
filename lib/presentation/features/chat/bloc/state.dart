import 'package:flutter/material.dart';
import 'package:sober_driver_analog/domain/firebase/chat/models/chat.dart';

import '../../../utils/status_enum.dart';

class ChatState {
  final Chat? chat;
  final ChatStateStatus? status;
  final TextEditingController? controller;
  final ScrollController? scrollController;

  ChatState( {this.scrollController, this.controller,this.chat, this.status = ChatStateStatus.success,});
}

enum ChatStateStatus {
  pageLoading,
  sending,
  chatDoesNotExist,
  sendingError,
  success,
}