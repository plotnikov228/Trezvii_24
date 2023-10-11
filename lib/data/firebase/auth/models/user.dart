import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/firebase/auth/models/user_model.dart';

part 'user.g.dart';
@JsonSerializable()
class User extends UserModel {
  @override
  final String userId;
  @override
  final String number;
  @override
  final String email;
  @override
  final String name;
  @override
  final DateTime registrationDate;
  final int bonuses;

  User(
      {
        required this.bonuses,
        required this.userId,
        required this.number,
        required super.ratings,
        super.blocked = false,
        required this.email,
        required this.name,
        required this.registrationDate}) : super(userId: userId, number: number, email: email, name: name, registrationDate: registrationDate);

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  Map<String, dynamic> toDB() => <String, dynamic>{
    'userId': userId,
    'number': number,
    'email': email,
    'name': name,
    'ratings': ratings.join(',') ,
    'registrationDate': registrationDate.toIso8601String(),
    'bonuses': bonuses,
  };

  factory User.fromDB(Map<String, dynamic> json) {
    return User(bonuses: json['bonuses'] as int,
    userId: json['userId'] as String,
    number: json['number'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    ratings: (json['ratings'] as String).split(',').map((e) => double.parse(e)).toList(),
    registrationDate: DateTime.parse(json['registrationDate'] as String));
  }
}
