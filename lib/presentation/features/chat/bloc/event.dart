abstract class ChatEvent {}

class SendMessageChatEvent extends ChatEvent {}

class LoadChatEvent extends ChatEvent {
  final String chatId;

  LoadChatEvent(this.chatId);
}