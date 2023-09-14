
import 'package:json_annotation/json_annotation.dart';
part 'tariff.g.dart';
@JsonSerializable()
class Tariff {
  final String name;
  final String description;
  final String displayCost;
  final String? startPriceKey;
  final bool checkOutCity;
  final String? theCostOfFirstHoursKey;
  final String? kmPriceKey;
  final String? hourPriceKey;
  final int? hoursCount;
  final String? kmPriceInVillageKey;

  Tariff(
      {required this.name,required this.checkOutCity,required this.description,
        required this.displayCost,
      required this.theCostOfFirstHoursKey,
      required this.kmPriceKey,required this.startPriceKey,
        required this.hourPriceKey,
      this.hoursCount,
      required this.kmPriceInVillageKey});

  factory Tariff.fromJson(Map<String, dynamic> json) => _$TariffFromJson(json);
  Map<String,dynamic> toJson () => _$TariffToJson(this);

}
