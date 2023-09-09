import 'package:json_annotation/json_annotation.dart';

import 'chat_messages.dart';

part 'chat.g.dart';
@JsonSerializable()
class Chat {
  String? id;
  final String driverId;
  final String employerId;

  Chat({required this.driverId, required this.employerId,});


  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}