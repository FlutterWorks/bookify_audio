// ignore_for_file: deprecated_member_use

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:test/page/setting/screen/app_information_page.dart';
import 'package:test/page/setting/screen/change_log_page.dart';
import 'package:test/page/setting/widgets/bookify_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool connectionStatus = true;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    try {
      List<ConnectivityResult> results =
          await _connectivity.checkConnectivity();
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi)) {
        setState(() {
          connectionStatus = true;
        });
      } else {
        setState(() {
          connectionStatus = false;
        });
      }
    } catch (e) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
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
          connectionStatus
              ? const BookifyAds(
                  apiUrl:
                      'https://apon06.github.io/bookify_api/ads/bookify_ads_1.json',
                )
              : const SizedBox(),
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
        ],
      ),
    );
  }
}
