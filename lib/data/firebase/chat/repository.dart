import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sober_driver_analog/domain/firebase/chat/models/chat.dart';

import 'package:sober_driver_analog/domain/firebase/chat/models/chat_messages.dart';

import '../../../domain/firebase/chat/repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final _instance = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> _chatCollection () => _instance.collection('Chats');

  @override
  Future<Chat> createChat(String driverId, String employerId) async {
    final doc = await _chatCollection().add(Chat(driverId: driverId, employerId: employerId).toJson());
    final chat = Chat.fromJson((await doc.get()).data()!);
    chat.id = doc.id;
    return chat;
  }

  @override
  Future deleteChat(String driverId, String employerId) async {
    final chat = await findChat(driverId, employerId);
    if(chat != null) {
      _chatCollection().doc(chat.id).delete();
    }
  }

  @override
  Future<Chat?> findChat(String driverId, String employerId) async {
    final doc = await _chatCollection().where('employerId', isEqualTo: employerId).where('driverId', isEqualTo: driverId).get();
    if(doc.docs.isNotEmpty) {
      final chat = Chat.fromJson(doc.docs.first.data());
      chat.id =doc.docs.first.id;
      return chat;
    }
  }

  @override
  Future sendMessageToChat(ChatMessages message, String chat) async {
    DocumentReference documentReference = _chatCollection()
        .doc(chat)
        .collection(chat)
        .doc(DateTime.now().toUtc().millisecondsSinceEpoch.toString());


    _instance.runTransaction((transaction) async {
      transaction.set(documentReference, message.toJson());
    });
  }

  @override
  Stream<List<ChatMessages>> getChatMessage(String chatId, int limit) {
    return _chatCollection()
        .doc(chatId)
        .collection(chatId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots().map((event) => event.docs.map((e) => ChatMessages.fromJson(e.data()!)).toList());
  }

  @override
  Future deleteChatById(String id) async {
    final doc = await _chatCollection().doc(id).delete();

  }

  @override
  Future<Chat?> findChatById(String id) async {
    final doc = await _chatCollection().doc(id).get();
    if(doc.exists) {
      return Chat.fromJson(doc.data()!);
    }
  }

}