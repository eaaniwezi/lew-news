import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lew_news/blocs/newsbloc/news_bloc.dart';
import 'package:lew_news/pages/landing_page.dart';
import 'package:lew_news/repositories/news_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>(
          create: (context) => NewsBloc(
            initialState: NewsInitState(),
            newsRespository: NewsRespository(),
          ),
          lazy: true,
        ),
     
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lew~News',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // ignore: prefer_const_constructors
        home: LandingPage(),
      ),
    );
  }
}
