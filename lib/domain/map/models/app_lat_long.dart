import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:json_annotation/json_annotation.dart';
part 'app_lat_long.g.dart';

@JsonSerializable()

class AppLatLong {
  final double lat;
  final double long;

  const AppLatLong({
    required this.lat,
    required this.long,
  });

  Point toPoint () {
    return Point(latitude: lat, longitude: long);
  }

  factory AppLatLong.fromJson (Map<String, dynamic> json) => _$AppLatLongFromJson(json);
  Map<String, dynamic> toJson () => _$AppLatLongToJson(this);
}



class KrasnodarLocation extends AppLatLong {
  const KrasnodarLocation({
    super.lat = 45.035470,
    super.long = 38.975313,
  });
}