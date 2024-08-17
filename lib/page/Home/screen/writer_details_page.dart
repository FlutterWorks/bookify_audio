import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/page/Home/screen/episode_page.dart';

class WriterDetailsPage extends StatefulWidget {
  final String api;
  final String writerImage;
  const WriterDetailsPage({
    super.key,
    required this.api,
    required this.writerImage,
  });

  @override
  State<WriterDetailsPage> createState() => _WriterDetailsPageState();
}

class _WriterDetailsPageState extends State<WriterDetailsPage> {
  List<dynamic> writerData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> getData() async {
    final res = await http.get(Uri.parse(widget.api));
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      writerData = decoded['audiobooks'];
      await saveDataToPreferences();
      setState(
        () {
          isLoading = false;
        },
      );
    } else {
      setState(
        () {
          isLoading = false;
        },
      );
    }
  }

  Future<void> saveDataToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("writerDetailSave", json.encode(writerData));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString("writerDetailSave");
    if (savedData != null) {
      writerData = json.decode(savedData);
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
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'hero-tag${widget.writerImage}',
                      child: SizedBox(
                        child: CachedNetworkImage(
                          imageUrl: widget.writerImage,
                          height: 350,
                          width: 250,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    if (writerData.isNotEmpty)
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(
                          writerData[0]['bookCreatorName'],
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: Colors.amber,
                          size: 50,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${writerData.last['id'].toString()} songs',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Text(
                            '67 minutes',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: writerData.length,
                    itemBuilder: (context, index) {
                      dynamic writer = writerData[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) =>
                                  EpisodeListPage(audiobook: writer),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 70,
                          child: ListTile(
                            leading: CachedNetworkImage(
                              width: 50,
                              height: 50,
                              imageUrl: writer['bookImage'],
                            ),
                            title: Text(
                              writer['bookName'],
                              style: const TextStyle(),
                            ),
                            trailing: const Icon(
                              Icons.navigate_next,
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
