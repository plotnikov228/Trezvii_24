
import 'package:json_annotation/json_annotation.dart';
part 'card.g.dart';

@JsonSerializable()
class UserCard {
  final String number;
  final String monthAndYear;
  final String cvvOrCvc;
  final String? email;

  UserCard(
      {required this.number,
      required this.monthAndYear,
      required this.cvvOrCvc,
      this.email});

  factory UserCard.fromJson(Map<String, dynamic> json) => _$UserCardFromJson(json);
  Map<String, dynamic> toJson () => _$UserCardToJson(this);
}
