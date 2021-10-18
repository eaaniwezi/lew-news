import 'package:flutter/material.dart';
import 'package:lew_news/style/theme.dart' as Style;
import 'package:transparent_image/transparent_image.dart';

class NewsContainer extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final Function newsDetailFunction;
  final Function bookMarkFunction;
  // final Function webViewFunction;
  final IconData bookMarkIcon;

  const NewsContainer({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.newsDetailFunction,
    required this.bookMarkFunction,
    // required this.webViewFunction,
    required this.bookMarkIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          // color: Style.Colors.titleColor,
          border: Border.all(color: Style.Colors.greenColor),
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        color: Style.Colors.greenColor),
                  ),
                ),
                SizedBox(
                  //  width: 238,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: FadeInImage.memoryNetwork(
                      image: imageUrl,
                      placeholder: kTransparentImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    // flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0,
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: SingleChildScrollView(
                          child: Text(
                            title,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: SingleChildScrollView(
                          child: Text(
                            "~ " + author,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              newsDetailFunction();
                            },
                            child: const Text(
                              "Continue reading",
                              style: TextStyle(
                                color: Style.Colors.greenColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              bookMarkFunction();
                            },
                            icon:
                                Icon(bookMarkIcon)
                              
                          )
                        ],
                      )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
