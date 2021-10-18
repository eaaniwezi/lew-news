import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lew_news/blocs/newsbloc/news_bloc.dart';
import 'package:lew_news/model/news_article_model.dart';
import 'package:lew_news/pages/news_page.dart';
import 'package:lew_news/style/theme.dart' as Style;
import 'package:lew_news/pages/bookmark_news_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  Widget? currentPage;

  late NewsPage newsPage;
  late BookMarkNewsPage bookMarkNewsPage;

  @override
  void initState() {
    super.initState();
    // ignore: prefer_const_constructors
    newsPage = NewsPage();
    // ignore: prefer_const_constructors
    bookMarkNewsPage = BookMarkNewsPage();
    pages = [newsPage, bookMarkNewsPage];
    currentPage = newsPage;
  }

  // ignore: prefer_final_fields
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsStates>(
      buildWhen: (oldState, newState) =>
          newState is NewsLoadingState ||
          newState is NewsLoadedState ||
          newState is NewsErrorState,
      builder: (context, state) {
        if (state is NewsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: Style.Colors.greenColor),
          );
        } else if (state is NewsLoadedState) {
          List<NewsArticleModel> _bookmarked = state.savedList;
          return PersistentTabView(
            context,
            controller: _controller,
            screens: pages,
            items: [
              PersistentBottomNavBarItem(
                  icon: const Icon(Icons.chrome_reader_mode_outlined),
                  title: ("News"),
                  activeColorPrimary: Style.Colors.greenColor,
                  inactiveColorPrimary: Style.Colors.titleColor),
              PersistentBottomNavBarItem(
                  icon: Icon(
                    _bookmarked.isEmpty
                        ? Icons.bookmark_border_rounded
                        : Icons.bookmark_outlined,
                  ),
                  title: (_bookmarked.isEmpty
                      ? "Bookmark"
                      : _bookmarked.length == 1
                          ? _bookmarked.length.toString() + " Bookmark"
                          : _bookmarked.length.toString() + " Bookmarks"),
                  activeColorPrimary: Style.Colors.greenColor,
                  inactiveColorPrimary: Style.Colors.titleColor),
            ],
            confineInSafeArea: true,
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            navBarStyle: NavBarStyle.style1, // Choose
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
    );
  }
}
