
import 'package:sober_driver_analog/domain/firebase/notification/repository.dart';

class UserSubscribeToPushes {
  final NotificationRepository repository;

  UserSubscribeToPushes(this.repository);

  Future<bool> call () => repository.userSubscribeToPushes();
}