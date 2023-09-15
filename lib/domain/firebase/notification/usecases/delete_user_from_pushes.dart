
import 'package:sober_driver_analog/domain/firebase/notification/repository.dart';

class DeleteUserFromPushes {
  final NotificationRepository repository;

  DeleteUserFromPushes(this.repository);

  Future call () => repository.deleteUserFromPushes();
}