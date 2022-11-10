import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

import '../res/constants.dart';
import '../res/custom_text_theme.dart';

class LatestNews extends StatefulWidget {
  const LatestNews({Key? key}) : super(key: key);

  @override
  State<LatestNews> createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
  late Future newsFuture;

  @override
  void initState() {
    Uri url = Uri.parse('${Constants.realtimeUrl}/news.json');
    newsFuture = http.get(url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Card(
        child: FutureBuilder(
            future: newsFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: ProgressRing(),
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
                final List news = jsonDecode(snapshot.data!.body) as List;
                return CarouselSlider.builder(
                  itemCount: news.length,
                  itemBuilder: (BuildContext context, int index, _) {
                    final singleNews = news[index];
                    return Stack(
                      children: [
                        Image.network(singleNews['imageLink'],fit: BoxFit.fill,width: double.infinity,),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 16.0,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(singleNews['title'],style: CustomTextTheme.header1,),
                                const SizedBox(height: 8.0,),
                                Text(singleNews['subtitle']),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  options: CarouselOptions(
                    height: 400,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.5,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    // onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  ),
                );
              }
              return const Center(
                child: Text('No news to view'),
              );
            }),
      ),
    );
  }
}
