// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lew_news/pages/all_news_page.dart';
import 'package:lew_news/pages/latest_news_page.dart';
import 'package:lew_news/style/theme.dart' as Style;

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lew~News"),
          backgroundColor: Style.Colors.mainColor,
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Style.Colors.secondColor,
            indicatorWeight: 5,
            tabs: [
              
              Tab(text: "Latest-News"),
              Tab(text: "All-News"),
            ],
          ),
        ),
        // ignore: prefer_const_literals_to_create_immutables
        body: TabBarView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            LatestNewsPage(),
            AllNewsPage(),
          ],
        ),
      ),
    );
  }
}
