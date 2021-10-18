import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lew_news/main_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    // ignore: prefer_const_constructors
    Timer( Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          // ignore: prefer_const_constructors
          builder: (BuildContext context) =>  MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: width * 0.9,
          height: width * 0.999,
          child: Image.asset(
            "images/image/landing.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
