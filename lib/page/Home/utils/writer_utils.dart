import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/page/Home/screen/writer_details_page.dart';

class WriterUtils extends StatefulWidget {
  const WriterUtils({super.key});

  @override
  State<WriterUtils> createState() => _WriterUtilsState();
}

class _WriterUtilsState extends State<WriterUtils> {
  List<dynamic> writerList = [];
  bool isLoading = true;

  Future<void> getData() async {
    final res = await http.get(
      Uri.parse('https://apon06.github.io/bookify_api/writer.json'),
    );
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      setState(() {
        writerList = decoded['WriterInfo'];
        isLoading = false;
      });
      await saveDataToPreferences();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveDataToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('WriterSaveKey', json.encode(writerList));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('WriterSaveKey');
    if (savedData != null) {
      setState(() {
        writerList = json.decode(savedData);
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
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: writerList.length,
        itemBuilder: (b, index) {
          var categoryApi = writerList[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WriterDetailsPage(
                  api: categoryApi["api"],
                  bookImage: categoryApi["bookImage"],
                  bookName: categoryApi["bookName"],
                  bookCreatorName: categoryApi["bookCreatorName"],
                  saveKey: categoryApi["saveKey"],
                  writerImage: categoryApi['writerImage'],
                ),
              ),
            ),
            child: CircleAvatar(
              radius: 75,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 70,
                backgroundImage:
                    CachedNetworkImageProvider(categoryApi["writerImage"]),
              ),
            ),
          );
        },
      ),
    );
  }
}
