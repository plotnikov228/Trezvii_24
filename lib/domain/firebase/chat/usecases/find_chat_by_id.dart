import 'package:sober_driver_analog/domain/firebase/chat/models/chat.dart';
import 'package:sober_driver_analog/domain/firebase/chat/models/chat_messages.dart';
import 'package:sober_driver_analog/domain/firebase/chat/repository.dart';

class FindChatById {
  final ChatRepository repository;

  FindChatById(this.repository);

  Future<Chat?> call ({required String id}) {
    return repository.findChatById(id);
  }
}