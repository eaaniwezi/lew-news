// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lew_news/style/theme.dart' as Style;
import 'package:equatable/equatable.dart';
import 'package:lew_news/model/news_article_model.dart';
import 'package:lew_news/repositories/news_repository.dart';

part 'news_events.dart';
part 'news_states.dart';

class NewsBloc extends Bloc<NewsEvents, NewsStates> {
  NewsRespository newsRespository;
  // StreamSubscription? _periodicSubscription;

  NewsBloc({
    required NewsStates initialState,
    required this.newsRespository,
  }) : super(initialState) {
    add(StartEvent());
  }

  @override
  Stream<NewsStates> mapEventToState(NewsEvents event) async* {
    if (event is StartEvent) {
      try {
        late List<NewsArticleModel> _allNewsArticleList;
        late List<NewsArticleModel> _allTrendingNewsArticleList;
        late List<NewsArticleModel> _allSavedArticleList;

        yield NewsLoadingState();

        _allNewsArticleList = await newsRespository.getAllNews(event.page);

        _allTrendingNewsArticleList = await newsRespository.getLatestNews();
        _allSavedArticleList = await newsRespository.getSavedNews();

        // ignore: prefer_conditional_assignment
      //   if (_periodicSubscription == null) {
      //     _periodicSubscription ??=
      //         Stream.periodic(const Duration(seconds: 5), (x) => x)
      //             .listen((event) => add(SaveArticleEvent(model: NewsArticleModel)), onError: (error) {
      //       print("refetch");
      //       print("Do something with $error");
      //     });
      //   } else {
      //   _periodicSubscription!.resume();
      // }
        yield NewsLoadedState(
          latestNewsArticleList: _allTrendingNewsArticleList,
          allNewsArticleList: _allNewsArticleList,
          savedList: _allSavedArticleList,
        );
        // yield NewsLoadedState(newsArticleList: _allTrendingNewsArticleList);
      } catch (e) {
        print(e);
        if (e is HttpException) {
          Fluttertoast.showToast(
              msg: "Couldn't load data",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Style.Colors.redColor,
              textColor: Style.Colors.whiteColor,
              fontSize: 16.0);
          yield NewsErrorState(errorMessage: "Couldn't load data");
        } else if (e is! HttpException) {
          Fluttertoast.showToast(
              msg: "Check your internet",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Style.Colors.redColor,
              textColor: Style.Colors.whiteColor,
              fontSize: 16.0);
          yield NewsErrorState(errorMessage: "Check your internet");
        }
      }
    } else if (event is SaveArticleEvent) { 
      if (state is NewsLoadedState) {
        final loadedState = state as NewsLoadedState;

        yield NewsLoadedState(
            allNewsArticleList: loadedState.allNewsArticleList,
            latestNewsArticleList: loadedState.latestNewsArticleList,
            savedList: [...loadedState.savedList, event.model]);
        await newsRespository.saveArticle(event.model);
      }
    } else if (event is RemoveArticleEvent) { 
      final _x = state as NewsLoadedState;
      final loadedState = NewsLoadedState(
          allNewsArticleList: _x.allNewsArticleList,
          latestNewsArticleList: _x.latestNewsArticleList,
          savedList: [..._x.savedList]);
      yield NewsInitState();

      final _removed = [...loadedState.savedList..remove(event.model)];
      final newList = List<NewsArticleModel>.of(_removed);

      await newsRespository.removeArticle(event.model);
      yield NewsLoadedState(
          allNewsArticleList: loadedState.allNewsArticleList,
          latestNewsArticleList: loadedState.latestNewsArticleList,
          savedList: newList.toList());
    } 
    // else if (event is ReFetchEvent) {
    //   final _y = state as NewsLoadedState;
    // }
  }

  @override
  void onChange(Change<NewsStates> change) {
    print(change.currentState);
    super.onChange(change);
  }

  @override
  void onEvent(NewsEvents event) {
    print(event);
    super.onEvent(event);
  }
}
