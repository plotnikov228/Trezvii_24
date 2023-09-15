
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/firebase/notification/repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {

  final _pushEnableKey = 'pushEnable';
  final _emailEnableKey = 'emailEnable';


  @override
  Future addUserToNewsletter() {
    // TODO: implement addUserToNewsletter
    throw UnimplementedError();
  }

  @override
  Future addUserToPushes() async {
    FirebaseMessaging.instance.requestPermission().then((value) async {
      FirebaseMessaging.instance.subscribeToTopic('all');
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_pushEnableKey, false);
    });
  }



  @override
  Future deleteUserFromNewsletter() async {
    FirebaseMessaging.instance.unsubscribeFromTopic('all');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushEnableKey, true);
  }

  @override
  Future deleteUserFromPushes() {
    // TODO: implement deleteUserFromPushes
    throw UnimplementedError();
  }

  @override
  Future<bool> userSubscribeToNewsletter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_emailEnableKey) ?? false;
  }

  @override
  Future<bool> userSubscribeToPushes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('_pushEnableKey') ?? false;
  }

}Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}