import 'package:flutter/material.dart';
import 'package:startapp_sdk/startapp.dart';
import '../../../firebase/database.dart';
import '../widgets/setting_field_button_widget.dart';
import '../widgets/setting_field_widget.dart';
// import 'package:google_fonts/google_fonts.dart';

class MissingStory extends StatefulWidget {
  const MissingStory({super.key});

  @override
  State<MissingStory> createState() => _MissingStoryState();
}

class _MissingStoryState extends State<MissingStory> {
  final TextEditingController bookAdd = TextEditingController();
  var startApp = StartAppSdk();
  StartAppBannerAd? bannerAds;

  loadBannerAds() {
    startApp.setTestAdsEnabled(true);
    startApp.loadBannerAd(StartAppBannerType.BANNER).then((value) {
      setState(() {
        bannerAds = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // _checkConnection();
    loadBannerAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Missing Story"),
      ),
      bottomNavigationBar: bannerAds != null
          ? SizedBox(height: 60, child: StartAppBanner(bannerAds!))
          : const SizedBox(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'প্রিয় ব্যবহারকারী,আমাদের অ্যাপটি নতুন, তাই আপনার পছন্দের গল্পগুলো এখনো নাও থাকতে পারে। অনুগ্রহ করে আপনার প্রিয় গল্পগুলোর নাম জানিয়ে আমাদের সহযোগিতা করুন।',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            SettingFieldWidget(
              hintText: 'Adds Missing Book Name only',
              textEditingController: bookAdd,
            ),
            const SizedBox(height: 15),
            SettingFieldButtonWidget(
              buttonText: 'Add',
              onTap: () async {
                Map<String, dynamic> addQuiz = {
                  'Story': bookAdd.text,
                };
                await DataBaseMethods()
                    .addQuizCategory(addQuiz, 'Missing')
                    .then(
                  (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Upload Complate'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                );
                setState(() {
                  bookAdd.text = '';
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
