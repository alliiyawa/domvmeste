import "package:dom_vmeste/data/models/news_models.dart";
abstract class NewsState {}

class NewsInitialState extends NewsState {}

class NewsLoadingState extends NewsState{}

class NewsLoadedState extends NewsState {
  final List<NewsModels> news;

  NewsLoadedState({required this.news});
}

class NewsErrorState extends NewsState {
  final String message;
  NewsErrorState({required this.message});
}