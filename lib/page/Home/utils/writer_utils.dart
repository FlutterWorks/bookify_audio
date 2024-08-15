import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/page/Home/screen/writer_details_page.dart';

class WriterUtils extends StatefulWidget {
  const WriterUtils({super.key});

  @override
  State<WriterUtils> createState() => _WriterUtilsState();
}

class _WriterUtilsState extends State<WriterUtils> {
  List<dynamic> homePageList = [];
  bool isLoading = true;
  dynamic selectedPerson;

  Future<void> getData() async {
    final res = await http.get(
      Uri.parse('https://apon06.github.io/bookify_api/writer.json'),
    );
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      setState(() {
        homePageList = decoded['WriterInfo'];
        isLoading = false;
        selectedPerson = homePageList.isNotEmpty ? homePageList[0] : null;
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
    prefs.setString('WriterSaveKey', json.encode(homePageList));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('WriterSaveKey');
    if (savedData != null) {
      setState(() {
        homePageList = json.decode(savedData);
        selectedPerson = homePageList.isNotEmpty ? homePageList[0] : null;
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
    dynamic writerPageApi;
    return isLoading
        ? const CircularProgressIndicator()
        : SizedBox(
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 3),
                  child: AutoSizeText(
                    'লেখক',
                    minFontSize: 20,
                    maxFontSize: 25,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (builder) => WriterDetailsPage(
                          api: writerPageApi['api'],
                          writerImage: writerPageApi['writerImage'],
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 130,
                    child: ListView.builder(
                        itemCount: homePageList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (b, index) {
                          writerPageApi = homePageList[index];
                          return Padding(
                            padding: const EdgeInsets.all(4),
                            child: SizedBox(
                              height: 130,
                              width: 130,
                              child: CircleAvatar(
                                radius: 130,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 125,
                                  backgroundImage: CachedNetworkImageProvider(
                                    writerPageApi["writerImage"],
                                    maxHeight: 125,
                                    maxWidth: 125,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          );
  }
}
