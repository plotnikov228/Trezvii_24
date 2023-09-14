import 'package:sober_driver_analog/domain/firebase/news/models/news_model.dart';

class NewsState {
  final List<NewsModel> news;

  NewsState({this.news = const[]});
}