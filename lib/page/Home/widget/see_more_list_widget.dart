import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:startapp_sdk/startapp.dart';
import 'package:test/page/Home/screen/episode_page.dart';

import '../../setting/widgets/bookify_ads.dart';

class SeeMoreListWidget extends StatefulWidget {
  final String api;
  final String bookImage;
  final String bookName;
  final String bookCreatorName;
  final String saveKey;
  const SeeMoreListWidget({
    super.key,
    required this.api,
    required this.bookImage,
    required this.bookName,
    required this.bookCreatorName,
    required this.saveKey,
  });

  @override
  State<SeeMoreListWidget> createState() => _SeeMoreListWidgetState();
}

class _SeeMoreListWidgetState extends State<SeeMoreListWidget> {
  List<dynamic> data = [];
  String bookType = '';

  // var startApp = StartAppSdk();
  // StartAppBannerAd? bannerAds;

  // loadBannerAds() {
  //   //! startApp.setTestAdsEnabled(true);
  //   startApp.loadBannerAd(StartAppBannerType.BANNER).then((value) {
  //     setState(() {
  //       bannerAds = value;
  //     });
  //   });
  // }

  Future<void> loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? savedValue = sharedPreferences.getStringList(widget.saveKey);
    String? bookTypeSaveValue =
        sharedPreferences.getString("${widget.saveKey}_bookType");
    if (savedValue != null && bookTypeSaveValue != null) {
      setState(() {
        data = savedValue.map((e) => json.decode(e)).toList();
        bookType = json.decode(bookTypeSaveValue);
      });
    }
  }

  Future<void> fetchData() async {
    var res = await http.get(Uri.parse(widget.api));
    if (res.statusCode == 200) {
      var decodedData = json.decode(res.body);
      var datad = decodedData['audiobooks'];
      var bookTyped = decodedData['bookType'];

      setState(() {
        data = datad;
        bookType = bookTyped;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setStringList(
          widget.saveKey, data.map((e) => json.encode(e)).toList());
      sharedPreferences.setString(
          "${widget.saveKey}_bookType", json.encode(bookType));
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    // loadBannerAds();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          bookType,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      // bottomNavigationBar: bannerAds != null
      //     ? SizedBox(height: 60, child: StartAppBanner(bannerAds!))
      //     : const SizedBox(),
      bottomNavigationBar: const BookifyAds(
        apiUrl: 'https://apon06.github.io/bookify_api/ads/see_more.json',
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          var book = data[index];
          return Padding(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (b) => EpisodeListPage(
                      audiobook: book,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                child: SizedBox(
                  height: 135,
                  width: MediaQuery.of(context).size.width * .99,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 120,
                                width: 100,
                                child: CachedNetworkImage(
                                  imageUrl: book[widget.bookImage],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("নাম: ${book[widget.bookName]}"),
                                  Text('লেখক: ${book[widget.bookCreatorName]}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
