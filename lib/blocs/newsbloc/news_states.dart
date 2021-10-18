part of 'news_bloc.dart';

class NewsStates extends Equatable {
  const NewsStates();

  @override
  List<Object?> get props => [];
}

class NewsInitState extends NewsStates {}

class NewsLoadingState extends NewsStates {}

class NewsLoadedState extends NewsStates {
  final List<NewsArticleModel> allNewsArticleList;
  final List<NewsArticleModel> latestNewsArticleList;
  final List<NewsArticleModel> savedList;
  // ignore: prefer_const_constructors_in_immutables
  NewsLoadedState({
    required this.allNewsArticleList,
    required this.latestNewsArticleList,
    required this.savedList,
  });

  @override
  List<Object?> get props => [...savedList];
}

class NewsErrorState extends NewsStates {
  final String errorMessage;
  // ignore: prefer_const_constructors_in_immutables
  NewsErrorState({required this.errorMessage});
}
