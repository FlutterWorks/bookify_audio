// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:test/core/star_the_project.dart';
// import 'package:test/page/Home/utils/app_bar_util.dart';
// import 'package:test/page/Home/utils/slider_image_utils.dart';
// import 'package:test/page/Home/widget/home_page_list_widget.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<dynamic> homePageList = [];
//   bool isLoading = true;
//   dynamic selectedPerson;

//   Future<void> getData() async {
//     final res = await http.get(
//       Uri.parse('https://apon06.github.io/bookify_api/homepage_api.json'),
//     );
//     if (res.statusCode == 200) {
//       final decoded = json.decode(res.body);
//       setState(() {
//         homePageList = decoded['HomePageApi'];
//         isLoading = false;
//         selectedPerson = homePageList.isNotEmpty ? homePageList[0] : null;
//       });
//       await saveDataToPreferences();
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> saveDataToPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('HomeSaveKey', json.encode(homePageList));
//   }

//   Future<void> loadData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedData = prefs.getString('HomeSaveKey');
//     if (savedData != null) {
//       setState(() {
//         homePageList = json.decode(savedData);
//         selectedPerson = homePageList.isNotEmpty ? homePageList[0] : null;
//         isLoading = false;
//       });
//     }
//     await getData();
//   }

//   Future<void> refreshData() async {
//     setState(() {
//       isLoading = true;
//     });
//     await getData();
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       GitHubStarPrompt.checkAndShowDialog(context);
//     });
//     loadData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: const [
//           AppBarUtil(),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SafeArea(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const ImageSliderScreen(),
//                     ListView.builder(
//                       physics:
//                           const NeverScrollableScrollPhysics(), // Disable the ListView's own scrolling
//                       shrinkWrap: true,
//                       itemCount: homePageList.length,
//                       itemBuilder: (b, index) {
//                         dynamic homePageApi = homePageList[index];
//                         return HomePageListWidget(
//                           api: homePageApi["api"],
//                           bookType: homePageApi["bookType"],
//                           bookImage: "bookImage",
//                           saveKey: homePageApi["saveKey"],
//                           bookCreatorName: 'bookCreatorName',
//                           bookName: "bookName",
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

// //                     // HomePageListWidget(
// //                     //   api:
// //                     //       'https://apon06.github.io/bookify_api/dummy_api.json',
// //                     //   bookType: 'bookType',
// //                     //   bookImage: "bookImage",
// //                     //   saveKey: 'save_bangladesh',
// //                     //   bookCreatorName: 'bookCreatorName',
// //                     //   bookName: "bookName",
// //                     // ),

import 'package:flutter/material.dart';
import 'package:test/page/Home/utils/writer_utils.dart';
import 'package:test/page/Home/utils/app_bar_util.dart';
import 'package:test/page/Home/utils/category_list_utils.dart';
import 'package:test/page/Home/utils/slider_image_utils.dart';
import 'package:test/page/Home/widget/home_page_list_widget.dart';

import '../../../firebase/config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     GitHubStarPrompt.checkAndShowDialog(context);
  //   });
  // }
  late Future<void> _initConfigFuture;

  @override
  void initState() {
    _initConfigFuture = Config.initConfig();
    super.initState();
    //  print(Config.url);
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          AppBarUtil(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ImageSliderScreen(),
              const SizedBox(height: 10),
              const CategoryListUtils(),
              FutureBuilder<void>(
                future: _initConfigFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  } else if (snapshot.hasError) {
                    return const CircularProgressIndicator();
                  } else {
                    return HomePageListWidget(
                      api: Config.url,
                      bookType: 'রবীন্দ্রনাথ ঠাকুর',
                      bookImage: "bookImage",
                      bookCreatorName: 'bookCreatorName',
                      bookName: "bookName", saveKey: 'save1',
                    );
                  }
                },
              ),
              const HomePageListWidget(
                api: 'https://apon06.github.io/bookify_api/dummy_api.json',
                bookType: 'রবীন্দ্রনাথ ঠাকুর',
                bookImage: "bookImage",
                bookCreatorName: 'bookCreatorName',
                bookName: "bookName", saveKey: 'save2',
              ),
              const WriterUtils(),
            ],
          ),
        ),
      ),
    );
  }
}
