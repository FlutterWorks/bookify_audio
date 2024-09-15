// ignore_for_file: deprecated_member_use

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:test/page/setting/screen/about_bookify.dart';
import 'package:test/page/setting/screen/app_information_page.dart';
import 'package:test/page/setting/screen/change_log_page.dart';
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
      setState(() {
        // connectionStatus = 'Failed to get connectivity';
      });
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
          connectionStatus == true
              ? GestureDetector(
                  onTap: () async {
                    const String playStoreUrl =
                        'https://play.google.com/store/apps/details?id=com.kbeauty.bangladesh&hl=en_US';

                    final Uri playStoreAppUrl = Uri.parse(playStoreUrl);
                    final Uri webUrl = Uri.parse(playStoreUrl);

                    if (await canLaunch(playStoreAppUrl.toString())) {
                      await launch(playStoreAppUrl.toString());
                    } else {
                      await launch(webUrl.toString());
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.grey[800],
                    ),
                    height: 60,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 10),
                              Image.network(
                                "https://i.postimg.cc/vB37vkP1/gora.jpg",
                                height: 50,
                              ),
                              const SizedBox(width: 15),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rosa Cosmatic Shop",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Cosmatic , Female Cosmatic",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                height: 40,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Center(
                                  child: Text("Install"),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
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
