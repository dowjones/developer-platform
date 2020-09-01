import 'package:bloc/bloc.dart';
import 'package:flutter_news_app/src/api/api_repository.dart';
import 'package:flutter_news_app/src/model/topstories/topstories.dart';

abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataSucessTopStories extends DataState {
  final TopStories data;
  final String name;

  DataSucessTopStories({this.data, this.name});
}

class DataFailed extends DataState {
  final String errorMessage;

  DataFailed(this.errorMessage);
}

class DataEvent {
  final String category;

  DataEvent({this.category});
}

class HomeBloc extends Bloc<DataEvent, DataState> {
  TopStories data;
  @override
  DataState get initialState => DataInitial();

  @override
  Stream<DataState> mapEventToState(DataEvent event) async* {
    yield DataLoading();
    final apiRepository = ApiRepository();
    final categoryLowerCase = event.category.toLowerCase();
    switch (categoryLowerCase) {
      case 'all':
        final data = await apiRepository.fetchTopStories();
        this.data = data;
        if (data != null) {
          yield DataSucessTopStories(data: data, name: categoryLowerCase);
        } else {
          yield DataFailed('Error with data');
        }
        break;
      default:
        final data = this.data ?? await apiRepository.fetchTopStories();
        if (data != null) {
          yield DataSucessTopStories(data: data, name: categoryLowerCase);
        } else {
          yield DataFailed('Error with data');
        }
        break;
    }
  }
}