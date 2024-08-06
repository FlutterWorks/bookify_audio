import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/page/Home/screen/episode_page.dart';

class SeeMoreListWidget extends StatefulWidget {
  final String api;
  final String bookType;
  final String bookImage;
  final String saveKey;
  final String bookName;
  final String bookCreatorName;
  const SeeMoreListWidget({
    super.key,
    required this.api,
    required this.bookType,
    required this.bookImage,
    required this.saveKey,
    required this.bookName,
    required this.bookCreatorName,
  });

  @override
  State<SeeMoreListWidget> createState() => _SeeMoreListWidgetState();
}

class _SeeMoreListWidgetState extends State<SeeMoreListWidget> {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.bookType,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: refreshData,
              child: ListView.builder(
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
                        // color: Colors.white,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("নাম: ${book[widget.bookName]}"),
                                          Text(
                                              'লেখক: ${book[widget.bookCreatorName]}'),
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
            ),
    );
  }
}
