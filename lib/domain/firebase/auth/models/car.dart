import 'package:json_annotation/json_annotation.dart';
part 'car.g.dart';
@JsonSerializable()
class Car {
  final String color;
  final String model;
  final String number;
  final String brand;
  final String releaseDate;

  Car({required this.color, required this.model, required this.number, required this.brand, required this.releaseDate});

  factory Car.fromJson (Map<String,dynamic> json) => _$CarFromJson(json);
  Map<String, dynamic> toJson () => _$CarToJson(this);

}