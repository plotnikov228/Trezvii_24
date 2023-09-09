import 'package:sober_driver_analog/domain/firebase/chat/models/chat.dart';
import 'package:sober_driver_analog/domain/firebase/chat/models/chat_messages.dart';
import 'package:sober_driver_analog/domain/firebase/chat/repository.dart';

class SendMessageToChat {
  final ChatRepository repository;

  SendMessageToChat(this.repository);

  Future<Chat> call ({required ChatMessages message, required Chat chat}) {
    return repository.sendMessageToChat(message, chat);
  }
}