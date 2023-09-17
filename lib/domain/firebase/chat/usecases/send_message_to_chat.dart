import 'package:sober_driver_analog/domain/firebase/chat/models/chat.dart';
import 'package:sober_driver_analog/domain/firebase/chat/models/chat_messages.dart';
import 'package:sober_driver_analog/domain/firebase/chat/repository.dart';

class SendMessageToChat {
  final ChatRepository repository;

  SendMessageToChat(this.repository);

  Future call ({required ChatMessages message, required String chatId}) {
    return repository.sendMessageToChat(message, chatId);
  }
}