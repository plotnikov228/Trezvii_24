
import 'package:json_annotation/json_annotation.dart';
part 'penalty.g.dart';

@JsonSerializable()
class Penalty {
  final DateTime dateTime;
  final String userId;
  final double cost;

  Penalty({required this.dateTime, required this.userId, required this.cost, });
  factory Penalty.fromJson(Map<String, dynamic> json) => _$PenaltyFromJson(json);
  Map<String,dynamic> toJson() =>_$PenaltyToJson(this);

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return other is Penalty && other.cost == cost && other.dateTime == dateTime && other.userId == userId;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

}