abstract class NotificationRepository {
  Future addUserToNewsletter ();
  Future deleteUserFromNewsletter ();

  Future addUserToPushes ();
  Future deleteUserFromPushes ();

  Future<bool> userSubscribeToNewsletter ();
  Future<bool> userSubscribeToPushes ();
}