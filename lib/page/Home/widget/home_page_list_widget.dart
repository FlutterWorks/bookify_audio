import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/page/Home/screen/episode_page.dart';
import 'package:test/page/Home/screen/see_more.dart';

class HomePageListWidget extends StatefulWidget {
  final String api;
  final String bookImage;
  final String bookCreatorName;
  final String bookName;
  final String saveKey;
  const HomePageListWidget({
    super.key,
    required this.api,
    required this.bookImage,
    required this.bookCreatorName,
    required this.bookName,
    required this.saveKey,
  });

  @override
  State<HomePageListWidget> createState() => _HomePageListWidgetState();
}

class _HomePageListWidgetState extends State<HomePageListWidget> {
  List<dynamic> data = [];
  String bookType = '';

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
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = (screenWidth - 40) / 3;
    final double imageHeight = imageWidth * 1.5;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                bookType,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (b) => SeeMorePage(
                        api: widget.api,
                        bookImage: widget.bookImage,
                        bookName: widget.bookName,
                        bookCreatorName: widget.bookCreatorName,
                        saveKey: widget.saveKey,
                      ),
                    ),
                  );
                },
                child: const AutoSizeText(
                  'See More',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: imageHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                dynamic book = data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (builder) =>
                              EpisodeListPage(audiobook: book),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: book[widget.bookImage].toString(),
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: imageWidth,
                            height: imageHeight,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: imageWidth,
                            height: imageHeight,
                            color: Colors.grey[200],
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
