// import 'package:flutter/material.dart';
// import 'package:test/core/quick_action.dart';
// import 'package:test/page/Home/utils/app_bar_util.dart';
// import 'package:test/page/Home/utils/category_list_utils.dart';
// import 'package:test/page/Home/utils/slider_image_utils.dart';
// import 'package:test/page/Home/utils/writer_utils.dart';
// import 'package:test/page/Home/widget/home_page_list_widget.dart';
// import '../../../firebase/config.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late Future<void> _initConfigFuture;

//   @override
//   void initState() {
//     _initConfigFuture = Config.initConfig();
//     super.initState();
//     initializeAction(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: const [
//           AppBarUtil(),
//         ],
//       ),
//       body: FutureBuilder<void>(
//         future: _initConfigFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const SizedBox.shrink();
//           } else if (snapshot.hasError) {
//             return const CircularProgressIndicator();
//           } else {
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const ImageSliderScreen(),
//                   const SizedBox(height: 10),
//                   const CategoryListUtils(),
//                   //!  I know the logic in this code is really bad.Can someone help me improve the logic? Please share the fixed code when you're done.
//                   HomePageListWidget(
//                     api: Config.writer1,
//                     bookImage: "bookImage",
//                     bookCreatorName: 'bookCreatorName',
//                     bookName: "bookName",
//                     saveKey: 'writerSave1',
//                   ),
//                   HomePageListWidget(
//                     api: Config.writer2,
//                     bookImage: "bookImage",
//                     bookCreatorName: 'bookCreatorName',
//                     bookName: "bookName",
//                     saveKey: 'writerSave2',
//                   ),
//                   const WriterUtils(),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:test/core/quick_action.dart';
// import 'package:test/page/Home/utils/app_bar_util.dart';
// import 'package:test/page/Home/utils/category_list_utils.dart';
// import 'package:test/page/Home/utils/slider_image_utils.dart';
// import 'package:test/page/Home/utils/writer_utils.dart';
// import 'package:test/page/Home/widget/home_page_list_widget.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//     initializeAction(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: const [
//           AppBarUtil(),
//         ],
//       ),
//       body: const SingleChildScrollView(
//         child: Column(
//           children: [
//             SliderImageUtils(),
//             SizedBox(height: 10),
//             CategoryListUtils(),
//             HomePageListWidget(
//               api:
//                   "https://apon06.github.io/bookify_api/writer/rabindranath_thakur.json",
//               bookImage: "bookImage",
//               bookCreatorName: 'bookCreatorName',
//               bookName: "bookName",
//               saveKey: 'rabindranath',
//             ),
//             HomePageListWidget(
//               api:
//                   "https://apon06.github.io/bookify_api/writer/sarat_chandra_chattopadhyay.json",
//               bookImage: "bookImage",
//               bookCreatorName: 'bookCreatorName',
//               bookName: "bookName",
//               saveKey: 'sarat_chandra',
//             ),
//             HomePageListWidget(
//               api:
//                   "https://apon06.github.io/bookify_api/writer/kazi_nazrul_islam.json",
//               bookImage: "bookImage",
//               bookCreatorName: 'bookCreatorName',
//               bookName: "bookName",
//               saveKey: 'kazi_nazrul',
//             ),
//             WriterUtils(),
//             HomePageListWidget(
//               api:
//                   "https://apon06.github.io/bookify_api/writer/humayun_ahmed.json",
//               bookImage: "bookImage",
//               bookCreatorName: 'bookCreatorName',
//               bookName: "bookName",
//               saveKey: 'humayun_ahmed',
//             ),
//             HomePageListWidget(
//               api:
//                   "https://apon06.github.io/bookify_api/writer/vibhutibhushan_banerjee.json",
//               bookImage: "bookImage",
//               bookCreatorName: 'bookCreatorName',
//               bookName: "bookName",
//               saveKey: 'vibhutibhushan_banerjee',
//             ),
//             HomePageListWidget(
//               api:
//                   "https://apon06.github.io/bookify_api/writer/tara_shankar_banerjee.json",
//               bookImage: "bookImage",
//               bookCreatorName: 'bookCreatorName',
//               bookName: "bookName",
//               saveKey: 'tara_shankar',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/page/Home/utils/app_bar_util.dart';
import 'package:test/page/Home/utils/category_list_utils.dart';
import 'package:test/page/Home/utils/slider_image_utils.dart';
import 'package:test/page/Home/utils/writer_utils.dart';
import 'package:test/page/Home/widget/home_page_list_widget.dart';

import '../../../core/quick_action.dart';

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
      Uri.parse('https://apon06.github.io/bookify_api/homepage_api.json'),
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
                          "https://apon06.github.io/bookify_api/writer/rabindranath_thakur.json",
                      bookImage: "bookImage",
                      bookCreatorName: 'bookCreatorName',
                      bookName: "bookName",
                      saveKey: 'rabindranath',
                    ),
                    const HomePageListWidget(
                      api:
                          "https://apon06.github.io/bookify_api/writer/sarat_chandra_chattopadhyay.json",
                      bookImage: "bookImage",
                      bookCreatorName: 'bookCreatorName',
                      bookName: "bookName",
                      saveKey: 'sarat_chandra',
                    ),
                    const HomePageListWidget(
                      api:
                          "https://apon06.github.io/bookify_api/writer/kazi_nazrul_islam.json",
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
                        //       "https://apon06.github.io/bookify_api/writer/vibhutibhushan_banerjee.json",
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