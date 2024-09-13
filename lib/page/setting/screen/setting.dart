// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:test/page/setting/screen/about_bookify.dart';
import 'package:test/page/setting/screen/app_information_page.dart';
import 'package:test/page/setting/screen/change_log_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
                    builder: (b) => const AboutBookify(),
                  ),
                );
              },
              title: const Text('About Bookify'),
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
          //     onTap: () async {
          //       String privacyUrl = 'https://sites.google.com/view/toolify-hub/home';
          //       final Uri url = Uri.parse(privacyUrl);
          //       if (await canLaunch(url.toString())) {
          //         await launch(url.toString());
          //       } else {
          //         await launch(url.toString());
          //       }
          //     },
          //     title: const Text('Privacy Policy'),
          //     trailing: const Icon(Icons.privacy_tip),
          //   ),
          // ),
        ],
      ),
    );
  }
}
