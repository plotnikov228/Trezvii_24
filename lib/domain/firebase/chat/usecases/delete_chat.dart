import 'package:sober_driver_analog/domain/firebase/chat/models/chat.dart';
import 'package:sober_driver_analog/domain/firebase/chat/repository.dart';

class DeleteChat {
  final ChatRepository repository;

  DeleteChat(this.repository);

  Future call ({required String driverId, required String employerId}) {
    return repository.deleteChat(driverId, employerId);
  }
}