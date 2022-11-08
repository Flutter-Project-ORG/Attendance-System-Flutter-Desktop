import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

import '../res/contants.dart';

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
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(news[index]['title']),
                          Text(news[index]['subtitle']),
                        ],
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 400,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
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
