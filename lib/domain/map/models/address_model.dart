import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';
@JsonSerializable()
class AddressModel {
  final String addressName;
  final AppLatLong appLatLong;
  final String? name;

  AddressModel( {this.name, required this.addressName, required this.appLatLong});

  factory AddressModel.fromJson (Map<String, dynamic> json) => _$AddressModelFromJson(json);
  Map<String, dynamic> toJson () => _$AddressModelToJson(this);
}