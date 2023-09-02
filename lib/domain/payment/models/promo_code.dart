import 'package:json_annotation/json_annotation.dart';
part 'promo_code.g.dart';
@JsonSerializable()
class PromoCode {
  final String promo;
  final double discount;
  final List<String> activatedUsers;

  PromoCode(this.promo, this.discount, this.activatedUsers);

  factory PromoCode.fromJson (Map<String, dynamic> json) => _$PromoCodeFromJson(json);
  Map<String, dynamic> toJson() => _$PromoCodeToJson(this);
}