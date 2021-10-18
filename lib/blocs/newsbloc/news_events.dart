part of 'news_bloc.dart';

abstract class NewsEvents extends Equatable {
  const NewsEvents();

  @override
  List<Object> get props => [];
}

class StartEvent extends NewsEvents {
  final int page;
  StartEvent({this.page = 1});
}

// class  ReFetchEvent extends NewsEvents {

// }

class SaveArticleEvent extends NewsEvents {
  final NewsArticleModel model;
  const SaveArticleEvent({
    required this.model,
  });
}

class RemoveArticleEvent extends NewsEvents {
  final NewsArticleModel model;
  const RemoveArticleEvent({
    required this.model,
  });
}
