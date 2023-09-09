import 'package:sober_driver_analog/domain/firebase/chat/models/chat.dart';
import 'package:sober_driver_analog/domain/firebase/chat/repository.dart';

class DeleteChatById {
  final ChatRepository repository;

  DeleteChatById(this.repository);

  Future call ({required String id}) {
    return repository.deleteChatById(id);
  }
}