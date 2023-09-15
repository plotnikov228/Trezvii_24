
import 'package:sober_driver_analog/domain/firebase/notification/repository.dart';

class UserSubscribeToNewsletter {
  final NotificationRepository repository;

  UserSubscribeToNewsletter(this.repository);

  Future<bool> call () => repository.userSubscribeToNewsletter();
}