// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lew_news/pages/news_page_details.dart';
import 'package:lew_news/style/theme.dart' as Style;
import 'package:lew_news/blocs/newsbloc/news_bloc.dart';
import 'package:lew_news/model/news_article_model.dart';
import 'package:lew_news/widgets/news_contanier.dart';

class LatestNewsPage extends StatelessWidget {
  const LatestNewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsBloc = BlocProvider.of<NewsBloc>(context);
    return StreamBuilder(
        stream: Stream.periodic(Duration(seconds: 5)).asyncMap((i) => newsBloc),
        builder: (context, snapshot) {
          return Container(
            color: Colors.white,
            // margin: EdgeInsets.only(top: height * 0.08),
            child: BlocBuilder<NewsBloc, NewsStates>(
              buildWhen: (oldState, newState) =>
                  newState is NewsLoadingState ||
                  newState is NewsLoadedState ||
                  newState is NewsErrorState,
              builder: (BuildContext context, NewsStates state) {
                if (state is NewsLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Style.Colors.greenColor),
                  );
                } else if (state is NewsLoadedState) {
                  List<NewsArticleModel> _allLatestNewsArticleList = [];
                  List<NewsArticleModel> _bookmarked = state.savedList;
                  _allLatestNewsArticleList = state.latestNewsArticleList;
                  return ListView.builder(
                      itemCount: _allLatestNewsArticleList.length,
                      itemBuilder: (context, index) {
                        final model = _allLatestNewsArticleList[index];
                        return NewsContainer(
                          author: model.author.toString(),
                          bookMarkFunction: () {
                            context.read<NewsBloc>().add(
                                  _bookmarked.contains(model)
                                      ? RemoveArticleEvent(model: model)
                                      : SaveArticleEvent(model: model),
                                );
                          },
                          bookMarkIcon: !_bookmarked.contains(model)
                              ? Icons.bookmark_border_rounded
                              : Icons.bookmark_outlined,
                          imageUrl: model.urlToImage.toString().isEmpty
                              ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSojwMMYZgtiupM4Vzdb5iBeE4b0Mamf3AgrxQJR19Xa4oIWV5xun9a02Ggyh4bZAurP_c&usqp=CAU"
                              : model.urlToImage.toString(),
                          newsDetailFunction: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsPageDetails(
                                          newssArticleModel:
                                              _allLatestNewsArticleList[index],
                                        )));
                          },
                          title: model.title.toString(),
                        );
                      });
                } else if (state is NewsErrorState) {
                  String error = state.errorMessage;
                  return Center(child: Text(error));
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.green,
                  ));
                }
              },
            ),
          );
        });
  }
}
