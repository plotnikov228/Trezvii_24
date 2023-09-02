import '../../../../domain/firebase/auth/models/user_model.dart';

import 'package:json_annotation/json_annotation.dart';
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
        required this.email,
        required this.name,
        required this.registrationDate}) : super(userId: userId, number: number, email: email, name: name, registrationDate: registrationDate);

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
