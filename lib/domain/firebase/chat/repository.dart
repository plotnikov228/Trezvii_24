import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sober_driver_analog/domain/firebase/chat/models/chat_messages.dart';

import 'models/chat.dart';

abstract class ChatRepository {
  Future<Chat> createChat (String driverId, String employerId);

  Future<Chat?> findChat (String driverId, String employerId);
  Future deleteChat(String driverId, String employerId);

  Future<Chat?> findChatById (String id);
  Future deleteChatById(String id);

  Future<Chat> sendMessageToChat(ChatMessages message, Chat chat);

  Stream<List<ChatMessages>> getChatMessage(String chatId, int limit);

}