// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/page/setting/screen/app_information_page.dart';
import 'package:test/page/setting/screen/change_log_page.dart';
import 'package:test/page/setting/screen/missing_story.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../provider/theme_provider.dart';
import '../widgets/bookify_ads.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // var startApp = StartAppSdk();
  // StartAppBannerAd? bannerAds;

//   loadBannerAds() {
//   try {
//     startApp.loadBannerAd(StartAppBannerType.BANNER).then((value) {
//       setState(() {
//         bannerAds = value;
//       });
//     });
//   } catch (e) {
//     // print("Failed to load StartApp banner ad: $e");
//   }
// }

  @override
  void initState() {
    super.initState();
    // loadBannerAds();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      // bottomNavigationBar: bannerAds != null
      //     ? SizedBox(height: 60, child: StartAppBanner(bannerAds!))
      //     : const SizedBox(),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text('Theme'),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (b) => const AppInformationPage(),
                  ),
                );
              },
              title: const Text('App Information'),
              trailing: const Icon(Icons.info_rounded),
            ),
          ),
          const BookifyAds(
            apiUrl:
                'https://apon06.github.io/bookify_api/ads/setting_1.json',
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (b) => const ChangeLogPage(),
                  ),
                );
              },
              title: const Text('Changelog'),
              trailing: const Icon(Icons.history),
            ),
          ),
          // Card(
          //   child: ListTile(
          //     onTap: () {
          //       Navigator.of(context).push(
          //         MaterialPageRoute(
          //           builder: (b) => const AboutBookify(),
          //         ),
          //       );
          //     },
          //     title: const Text('About Bookify'),
          //     trailing: const Icon(Icons.info_rounded),
          //   ),
          // ),
          Card(
            child: ListTile(
              onTap: () async {
                String privacyUrl =
                    'https://sites.google.com/view/bookify-audio/home';
                final Uri url = Uri.parse(privacyUrl);
                if (await canLaunch(url.toString())) {
                  await launch(url.toString());
                } else {
                  await launch(url.toString());
                }
              },
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.privacy_tip),
            ),
          ),
          const BookifyAds(
            apiUrl:
                'https://apon06.github.io/bookify_api/ads/setting_2.json',
          ),

          Card(
            child: ListTile(
              onTap: () async {
                String privacyUrl = 'https://t.me/+iCD-EPh5ye1iM2Q1';
                final Uri url = Uri.parse(privacyUrl);
                if (await canLaunch(url.toString())) {
                  await launch(url.toString());
                } else {
                  await launch(url.toString());
                }
              },
              title: const Text('Telegram Group'),
              trailing: const Icon(Icons.telegram),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (b) => const MissingStory(),
                  ),
                );
              },
              title: const Text('Missing Story'),
              trailing: const Icon(Icons.add),
            ),
          ),
          const BookifyAds(
            apiUrl:
                'https://apon06.github.io/bookify_api/ads/setting_3.json',
          ),
        ],
      ),
    );
  }
}
