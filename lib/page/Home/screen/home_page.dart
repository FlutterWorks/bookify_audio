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

import 'package:flutter/material.dart';
import 'package:test/core/quick_action.dart';
import 'package:test/page/Home/utils/app_bar_util.dart';
import 'package:test/page/Home/utils/category_list_utils.dart';
import 'package:test/page/Home/utils/slider_image_utils.dart';
import 'package:test/page/Home/utils/writer_utils.dart';
import 'package:test/page/Home/widget/home_page_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
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
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ImageSliderScreen(),
            SizedBox(height: 10),
            CategoryListUtils(),
            HomePageListWidget(
              api:
                  "https://apon06.github.io/bookify_api/writer/rabindranath_thakur.json",
              bookImage: "bookImage",
              bookCreatorName: 'bookCreatorName',
              bookName: "bookName",
              saveKey: 'rabindranath',
            ),
            HomePageListWidget(
              api:
                  "https://apon06.github.io/bookify_api/writer/sarat_chandra_chattopadhyay.json",
              bookImage: "bookImage",
              bookCreatorName: 'bookCreatorName',
              bookName: "bookName",
              saveKey: 'sarat_chandra',
            ),
            HomePageListWidget(
              api:
                  "https://apon06.github.io/bookify_api/writer/kazi_nazrul_islam.json",
              bookImage: "bookImage",
              bookCreatorName: 'bookCreatorName',
              bookName: "bookName",
              saveKey: 'kazi_nazrul',
            ),
            WriterUtils(),
            HomePageListWidget(
              api:
                  "https://apon06.github.io/bookify_api/writer/humayun_ahmed.json",
              bookImage: "bookImage",
              bookCreatorName: 'bookCreatorName',
              bookName: "bookName",
              saveKey: 'humayun_ahmed',
            ),
            HomePageListWidget(
              api:
                  "https://apon06.github.io/bookify_api/writer/vibhutibhushan_banerjee.json",
              bookImage: "bookImage",
              bookCreatorName: 'bookCreatorName',
              bookName: "bookName",
              saveKey: 'vibhutibhushan_banerjee',
            ),
            HomePageListWidget(
              api:
                  "https://apon06.github.io/bookify_api/writer/tara_shankar_banerjee.json",
              bookImage: "bookImage",
              bookCreatorName: 'bookCreatorName',
              bookName: "bookName",
              saveKey: 'tara_shankar',
            ),
          ],
        ),
      ),
    );
  }
}
