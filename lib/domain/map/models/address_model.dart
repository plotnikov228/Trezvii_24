import 'package:sober_driver_analog/domain/map/models/app_lat_long.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';
@JsonSerializable()
class AddressModel {
  final String addressName;
  final AppLatLong appLatLong;
  final String? name;
  final String? entrance;
  final String? comment;
  final String? locality;
  AddressModel( {this.name,this.locality, this.comment,required this.addressName,this.entrance, required this.appLatLong});

  factory AddressModel.fromJson (Map<String, dynamic> json) => _$AddressModelFromJson(json);
  Map<String, dynamic> toJson () => _$AddressModelToJson(this);
  Map<String, dynamic> toDBFormat () =>
      <String, dynamic>{
        'addressName': addressName,
        'lat': appLatLong.lat,
        'long': appLatLong.long,
        'name': name,
        'entrance': entrance,
        'comment': comment,
        'locality': locality,

      };

  factory AddressModel.fromDB(Map<String, dynamic> json) => AddressModel(
    name: json['name'] as String?,
    comment: json['comment'] as String?,
    addressName: json['addressName'] as String,
    entrance: json['entrance'] as String?,
    locality: json['locality'],
    appLatLong:
    AppLatLong(lat: json['lat'], long: json['long']),
  );
}