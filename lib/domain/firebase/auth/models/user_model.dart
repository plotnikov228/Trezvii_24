import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';
@JsonSerializable(
  createFactory: false
)

abstract class UserModel {
  final String userId;
  final String number;
  final String email;
  final String name;
  final DateTime registrationDate;

  UserModel(
      {required this.userId,
  required this.number,
      required this.email,
      required this.name,
      required this.registrationDate});

  Map<String, dynamic> toJson () => _$UserModelToJson(this);
  Map<String, dynamic> toDB ();
}
