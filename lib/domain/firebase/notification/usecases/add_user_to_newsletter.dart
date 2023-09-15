
import 'package:sober_driver_analog/domain/firebase/notification/repository.dart';

class AddUserToNewsletter {
  final NotificationRepository repository;

  AddUserToNewsletter(this.repository);

  Future call () => repository.addUserToNewsletter();
}