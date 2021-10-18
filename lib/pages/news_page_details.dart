// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:lew_news/style/theme.dart' as Style;
import 'package:lew_news/model/news_article_model.dart';
import 'package:transparent_image/transparent_image.dart';

class NewsPageDetails extends StatefulWidget {
  final NewsArticleModel newssArticleModel;
  NewsPageDetails({Key? key, required this.newssArticleModel})
      : super(key: key);

  @override
  _NewsPageDetailsState createState() => _NewsPageDetailsState();
}

class _NewsPageDetailsState extends State<NewsPageDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.titleColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        elevation: 0,
        title: Text(widget.newssArticleModel.author.toString()),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _imageContainer(),
            Container(
              margin: const EdgeInsets.fromLTRB(16.0, 250.0, 16.0, 16.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0)),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.newssArticleModel.title.toString(),
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(widget.newssArticleModel.publishedAt.toString()),
                  const SizedBox(height: 10.0),
                  Text(widget.newssArticleModel.source!.name.toString()),
                  const Divider(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    widget.newssArticleModel.description.toString(),
                    textAlign: TextAlign.justify,
                  ),

                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () async {
                      if (Platform.isAndroid) {
                        FlutterWebBrowser.openWebPage(
                          url: widget.newssArticleModel.url.toString(),
                          customTabsOptions: CustomTabsOptions(
                            colorScheme: CustomTabsColorScheme.dark,
                            toolbarColor: Style.Colors.mainColor,
                            secondaryToolbarColor: Colors.green,
                            navigationBarColor: Style.Colors.greenColor,
                            addDefaultShareMenuItem: true,
                            instantAppsEnabled: true,
                            showTitle: true,
                            urlBarHidingEnabled: true,
                          ),
                        );
                      } else if (Platform.isIOS) {
                        FlutterWebBrowser.openWebPage(
                          url: widget.newssArticleModel.url.toString(),
                          safariVCOptions: SafariViewControllerOptions(
                            barCollapsingEnabled: true,
                            preferredBarTintColor: Style.Colors.mainColor,
                            preferredControlTintColor: Style.Colors.greenColor,
                            dismissButtonStyle:
                                SafariViewControllerDismissButtonStyle.close,
                            modalPresentationCapturesStatusBarAppearance: true,
                          ),
                        );
                      } else {
                        await FlutterWebBrowser.openWebPage(
                          url: widget.newssArticleModel.url.toString(),
                        );
                      }
                    },
                    child: Text(
                      "Read more",
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Style.Colors.greenColor),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageContainer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      child: Stack(
        children: [
          const Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(color: Style.Colors.greenColor),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: FadeInImage.memoryNetwork(
              image: widget.newssArticleModel.urlToImage.toString().isEmpty
                  ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSojwMMYZgtiupM4Vzdb5iBeE4b0Mamf3AgrxQJR19Xa4oIWV5xun9a02Ggyh4bZAurP_c&usqp=CAU"
                  : widget.newssArticleModel.urlToImage.toString(),
              placeholder: kTransparentImage,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
