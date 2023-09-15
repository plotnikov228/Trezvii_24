
import 'package:sober_driver_analog/domain/firebase/notification/repository.dart';

class AddUserToPushes {
  final NotificationRepository repository;

  AddUserToPushes(this.repository);

  Future call () => repository.addUserToPushes();
}