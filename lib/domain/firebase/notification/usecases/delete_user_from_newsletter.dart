
import 'package:sober_driver_analog/domain/firebase/notification/repository.dart';

class DeleteUserFromNewsletter {
  final NotificationRepository repository;

  DeleteUserFromNewsletter(this.repository);

  Future call () => repository.deleteUserFromNewsletter();
}