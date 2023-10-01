
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/firebase/notification/repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {

  final _pushEnableKey = 'pushEnable';
  final _emailEnableKey = 'emailEnable';

  final _subscribersCollection = 'SubscribersToNewsletter';

  final _instance = FirebaseFirestore.instance;

  @override
  Future addUserToPushes() async {
    await FirebaseMessaging.instance.requestPermission().then((value) async {
      FirebaseMessaging.instance.subscribeToTopic('all');
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_pushEnableKey, true);
    });
  }

  @override
  Future deleteUserFromPushes()  async{
    await FirebaseMessaging.instance.unsubscribeFromTopic('all');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushEnableKey, false);
  }

  @override
  Future addUserToNewsletter() async {
    await _instance.collection(_subscribersCollection).doc(FirebaseAuth.instance.currentUser!.uid).set({});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailEnableKey, true);
  }


  @override
  Future deleteUserFromNewsletter() async {
    await _instance.collection(_subscribersCollection).doc(FirebaseAuth.instance.currentUser!.uid).delete();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailEnableKey, false);
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