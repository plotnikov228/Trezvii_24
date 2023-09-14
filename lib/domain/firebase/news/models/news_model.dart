import 'package:json_annotation/json_annotation.dart';
part 'news_model.g.dart';
@JsonSerializable(
  createToJson: false
)
class NewsModel {
  final String title;
  final String content;
  final String date;

  NewsModel( {required this.date, required this.title, required this.content});

  factory NewsModel.fromJson(Map<String, dynamic> json) => _$NewsModelFromJson(json);
}