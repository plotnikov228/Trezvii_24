
import 'package:json_annotation/json_annotation.dart';
part 'order_for_another.g.dart';
@JsonSerializable()
class OrderForAnother {
  final String number;
  final String name;

  OrderForAnother(this.number, this.name);

  factory OrderForAnother.fromJson(Map<String, dynamic> json) => _$OrderForAnotherFromJson(json);
  Map<String, dynamic> toJson() => _$OrderForAnotherToJson(this);
}