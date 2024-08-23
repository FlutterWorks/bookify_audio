// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test/core/quick_action.dart';
import 'package:test/page/Home/utils/app_bar_util.dart';
import 'package:test/page/Home/utils/category_list_utils.dart';
import 'package:test/page/Home/utils/slider_image_utils.dart';
import 'package:test/page/Home/utils/writer_utils.dart';
import 'package:test/page/Home/widget/home_page_list_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../firebase/config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

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
    checkForUpdate();
    initializeAction(context);
  }

  Future<void> checkForUpdate() async {
    try {
      final response = await http.get(
          Uri.parse('https://apon06.github.io/bookify_api/app_update.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String latestVersion = data['latest_version'];
        String updateMessage = data['update_message'];

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String currentVersion = packageInfo.version;

        if (latestVersion != currentVersion) {
          showUpdateDialog(updateMessage);
        }
      } else {
        //
      }
    } catch (e) {
      //
    }
  }

  void showUpdateDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Available'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Later'),
          ),
          TextButton(
            onPressed: () async {
              const String appUpdateUrl =
                  'https://github.com/apon06/bookify_audio/releases';

              final Uri url = Uri.parse(appUpdateUrl);

              if (await canLaunch(url.toString())) {
                await launch(url.toString());
              } else {
                await launch(url.toString());
              }
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          AppBarUtil(),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initConfigFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          } else if (snapshot.hasError) {
            return const CircularProgressIndicator();
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const ImageSliderScreen(),
                  const SizedBox(height: 10),
                  const CategoryListUtils(),
                  //!  I know the logic in this code is really bad.Can someone help me improve the logic? Please share the fixed code when you're done.
                  HomePageListWidget(
                    api: Config.writer1,
                    bookImage: "bookImage",
                    bookCreatorName: 'bookCreatorName',
                    bookName: "bookName",
                    saveKey: 'writerSave1',
                  ),
                  HomePageListWidget(
                    api: Config.writer2,
                    bookImage: "bookImage",
                    bookCreatorName: 'bookCreatorName',
                    bookName: "bookName",
                    saveKey: 'writerSave2',
                  ),
                  const WriterUtils(),
                  // HomePageListWidget(
                  //   api: Config.writer3,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave3', jsonDecode: '',
                  // ),
                  // HomePageListWidget(
                  //   api: Config.writer4,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave4', jsonDecode: '',
                  // ),
                  // HomePageListWidget(
                  //   api: Config.writer5,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave5',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.writer6,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave6',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.writer7,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave7',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.writer8,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave8',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.writer9,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave9',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.writer10,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave10',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.writer11,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave11',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.writer12,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave12',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.writer13,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave13',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.writer14,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave14',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.writer15,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'writerSave15',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story1,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave1',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story2,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave2',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story3,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave3',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story4,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave4',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story5,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave5',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story6,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave6',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story7,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave7',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story8,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave8',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story9,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave9',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story10,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave10',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story11,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave11',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story12,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave12',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story13,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave13',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story14,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave14',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story15,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave15',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story16,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave16',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story17,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave17',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story18,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave18',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story19,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave19',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story20,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave20',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story21,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave21',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story22,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave22',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story23,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave23',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story24,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave24',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story25,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave25',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story26,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave26',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story27,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave27',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story28,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave28',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story29,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave29',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story30,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave30',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story31,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave31',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story32,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave32',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story33,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave33',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story34,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave34',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                  // HomePageListWidget(
                  //   api: Config.story35,
                  //   // bookType: 'রবীন্দ্রনাথ ঠাকুর',
                  //   bookImage: "bookImage",
                  //   bookCreatorName: 'bookCreatorName',
                  //   bookName: "bookName",
                  //   saveKey: 'storySave35',
                  //   jsonDecode:
                  //       '', // Add the required parameter with an appropriate value
                  // ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
