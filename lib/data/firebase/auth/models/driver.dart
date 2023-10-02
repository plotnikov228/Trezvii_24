import 'package:json_annotation/json_annotation.dart';
import 'package:sober_driver_analog/domain/firebase/auth/models/user_model.dart';

import '../../../../domain/firebase/auth/models/car.dart';
import '../../../../domain/firebase/auth/models/personal_data_of_the_driver.dart';
import '../../../../domain/map/models/app_lat_long.dart';

part 'driver.g.dart';
@JsonSerializable()
class Driver extends UserModel {
  final AppLatLong? currentPosition;
  final bool confirmed;
  final PersonalDataOfTheDriver? personalDataOfTheDriver;
  final Car? car;

  Driver({
    required this.confirmed,
    this.currentPosition,
    required super.ratings,
    required super.userId,
    super.blocked = false,
    required super.number,
    required super.email,
    required super.name,
    required super.registrationDate,
     this.personalDataOfTheDriver,
    this.car,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

  Driver copyWith(
      {PersonalDataOfTheDriver? personalDataOfTheDriver,
      Car? car,
      String? userId,
      String? number,
      String? email,
      String? name,
      List<double>? ratings,
      AppLatLong? currentPosition,
      bool? confirmed}) {
    return Driver(
        confirmed: confirmed ?? this.confirmed,
        ratings: ratings ?? this.ratings,
        userId: userId ?? this.userId,
        number: number ?? this.number,
        email: email ?? this.email,
        name: name ?? this.name,
        registrationDate: registrationDate,
        currentPosition: currentPosition ?? this.currentPosition,
        car: car,
        personalDataOfTheDriver:
            personalDataOfTheDriver ?? this.personalDataOfTheDriver);
  }

  @override
  Map<String, dynamic> toJson() => _$DriverToJson(this);

  @override
  Map<String, dynamic> toDB() => {
    'userId': userId,
    'number': number,
    'email': email,
    'name': name,
    'registrationDate': registrationDate.toIso8601String(),
    'bonuses': null,
    'ratings': ratings.join(',')
  };

  factory Driver.fromDB(Map<String, dynamic> json) {
    return Driver(
        userId: json['userId'] as String,
        number: json['number'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        ratings: (json['ratings'] as String).split(',').map((e) => double.parse(e)).toList(),
        registrationDate: DateTime.parse(json['registrationDate'] as String), confirmed: true, );
  }

  String getRating () {
    if (ratings.isEmpty) {
      return '0.0';
    }
    else {
      double total = ratings.reduce((a, b) => a + b);
      double average = total / ratings.length;
      return average.toString().length > 3 ? average.toString().substring(0, 3) : average.toString();
    }
  }
}
