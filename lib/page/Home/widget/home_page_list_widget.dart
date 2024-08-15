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
  final String bookType;
  final String bookImage;
  final String bookCreatorName;
  final String bookName;
  final String saveKey;
  const HomePageListWidget({
    super.key,
    required this.api,
    required this.bookType,
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> getData() async {
    final res = await http.get(
      Uri.parse(widget.api),
    );
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      data = decoded['audiobooks'];
      await saveDataToPreferences();
      setState(() {
        isLoading = false;
      });
    } else {
      // Handle the error accordingly
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveDataToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.saveKey, json.encode(data));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(widget.saveKey);
    if (savedData != null) {
      data = json.decode(savedData);
      setState(() {
        isLoading = false;
      });
    }
    await getData();
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = (screenWidth - 40) / 3;
    final double imageHeight = imageWidth * 1.5;

    return isLoading
        ? const CircularProgressIndicator()
        : RefreshIndicator(
            onRefresh: refreshData,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        widget.bookType,
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
                                bookType: widget.bookType,
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
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              dynamic book = data[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
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
                                        imageUrl:
                                            book[widget.bookImage].toString(),
                                        width: imageWidth,
                                        height: imageHeight,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          width: imageWidth,
                                          height: imageHeight,
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
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
            ),
          );
  }
}
