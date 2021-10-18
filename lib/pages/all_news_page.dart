// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_if_null_operators, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lew_news/blocs/newsbloc/news_bloc.dart';
import 'package:lew_news/pages/news_page_details.dart';
import 'package:lew_news/repositories/news_repository.dart';
import 'package:lew_news/style/theme.dart' as Style;
import 'package:lew_news/model/news_article_model.dart';
import 'package:lew_news/widgets/news_contanier.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class AllNewsPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  AllNewsPage({Key? key}) : super(key: key);

  @override
  State<AllNewsPage> createState() => _AllNewsPageState();
}

class _AllNewsPageState extends State<AllNewsPage> {
  int currentPage = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  NewsRespository newsRespository = NewsRespository();

  void _onRefresh(BuildContext context) async {
    context.read<NewsBloc>().add(StartEvent(page: ++currentPage));
    _refreshController.refreshCompleted();
    print("started refreshing");
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    CircularProgressIndicator();
    if (mounted) setState(() {});
    print("loading");
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BlocBuilder<NewsBloc, NewsStates>(
        buildWhen: (oldState, newState) =>
            newState is NewsLoadingState ||
            newState is NewsLoadedState ||
            newState is NewsErrorState,
        builder: (BuildContext context, NewsStates state) {
          if (state is NewsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: Style.Colors.greenColor),
            );
          } else if (state is NewsLoadedState) {
            List<NewsArticleModel> _allNewsArticleList = [];
            List<NewsArticleModel> _bookmarked = state.savedList;
            _allNewsArticleList = state.allNewsArticleList;
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              onRefresh: () => _onRefresh(context),
              onLoading: _onLoading,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: _allNewsArticleList.length,
                  itemBuilder: (context, index) {
                    final model = _allNewsArticleList[index];
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
                                          _allNewsArticleList[index],
                                    )));
                      },
                      title: model.title.toString(),
                    );
                  }),
            );
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
  }
}
