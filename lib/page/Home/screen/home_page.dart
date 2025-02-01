import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/quick_action.dart';
import '../utils/app_bar_util.dart';
import '../utils/category_list_utils.dart';
import '../utils/slider_image_utils.dart';
import '../utils/writer_utils.dart';
import '../widget/home_page_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> homePageList = [];
  bool isLoading = true;
  dynamic selectedPerson;

  Future<void> getData() async {
    final res = await http.get(
      Uri.parse('https://gokeihub.github.io/bookify_api/homepage_api.json'),
    );
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      setState(() {
        homePageList = decoded['HomePageApi'];
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
    prefs.setString('HomeSaveKey', json.encode(homePageList));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('HomeSaveKey');
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
    initializeAction(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          AppBarUtil(),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SliderImageUtils(),
                    const SizedBox(height: 10),
                    const CategoryListUtils(),
                    const HomePageListWidget(
                      api:
                          "https://gokeihub.github.io/bookify_api/writer/rabindranath_thakur.json",
                      bookImage: "bookImage",
                      bookCreatorName: 'bookCreatorName',
                      bookName: "bookName",
                      saveKey: 'rabindranath',
                    ),
                    const HomePageListWidget(
                      api:
                          "https://gokeihub.github.io/bookify_api/writer/sarat_chandra_chattopadhyay.json",
                      bookImage: "bookImage",
                      bookCreatorName: 'bookCreatorName',
                      bookName: "bookName",
                      saveKey: 'sarat_chandra',
                    ),
                    const HomePageListWidget(
                      api:
                          "https://gokeihub.github.io/bookify_api/writer/kazi_nazrul_islam.json",
                      bookImage: "bookImage",
                      bookCreatorName: 'bookCreatorName',
                      bookName: "bookName",
                      saveKey: 'kazi_nazrul',
                    ),
                    const WriterUtils(),
                    ListView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable the ListView's own scrolling
                      shrinkWrap: true,
                      itemCount: homePageList.length,
                      itemBuilder: (b, index) {
                        dynamic homePageApi = homePageList[index];
                        return HomePageListWidget(
                          api: homePageApi["api"],
                          bookImage: 'bookImage',
                          saveKey: homePageApi["bookType"],
                          bookCreatorName: 'bookCreatorName',
                          bookName: 'bookName',
                        );

                        //  return HomePageListWidget(
                        //   api:
                        //       "https://gokeihub.github.io/bookify_api/writer/vibhutibhushan_banerjee.json",
                        //   bookImage: "bookImage",
                        //   bookCreatorName: 'bookCreatorName',
                        //   bookName: "bookName",
                        //   saveKey: 'vibhutibhushan_banerjee',
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}


//                     // HomePageListWidget(
//                     //   api:
//                     //       'https://castor-parachutes.000webhostapp.com/apiforlink.php?token=1z14ecxgs1tbt9cb54sa',
//                     //   bookType: 'রবীন্দ্রনাথ ঠাকুর',
//                     //   bookImage: 'image',
//                     //   saveKey: 'save_bangladesh',
//                     //   bookCreatorName: 'bookCreatorName',
//                     //   bookName: 'title',
//                     // ),