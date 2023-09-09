class ChatMessages {
  String idFrom;
  String idTo;
  String timestamp;
  String content;

  ChatMessages(
      {required this.idFrom,
        required this.idTo,
        required this.timestamp,
        required this.content,});

  Map<String, dynamic> toJson() {
    return {
      'idFrom': idFrom,
      'idTo': idTo,
      'timestamp': timestamp,
      'content': content,
    };
  }

  factory ChatMessages.fromJson(Map<String, dynamic> json) {
    String idFrom = json['idFrom'];
    String idTo = json['idTo'];
    String timestamp = json['timestamp'];
    String content = json['content'];

    return ChatMessages(
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,);
  }
}