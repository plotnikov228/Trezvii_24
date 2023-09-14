import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sober_driver_analog/domain/firebase/news/models/news_model.dart';
import 'package:sober_driver_analog/presentation/features/home/menu/news/bloc/state.dart';


import '../../../../../../data/firebase/firestore/repository.dart';
import '../../../../../../domain/firebase/firestore/usecases/get_collection_data.dart';
import 'event.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc(super.initialState) {
    List<NewsModel> _news = [];

    on<InitNewsEvent>((event, emit) async {
        _news = (await GetCollectionData(FirebaseFirestoreRepositoryImpl()).call('News')).map((e) => NewsModel.fromJson(e)).toList();
        emit(NewsState(news: _news));
    });
  }
}

