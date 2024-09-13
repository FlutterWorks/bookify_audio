// ignore_for_file: deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test/firebase_options.dart';
import 'package:test/page/Home/screen/home_page.dart';
import 'package:test/page/person/screen/person_page.dart';
import 'package:test/page/setting/screen/setting.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreenPage(),
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(
      const Duration(milliseconds: 1200),
      () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StartPage()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 198, 194, 183),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splash.png',
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Turn silence into stories.',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
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

  final List<Widget> _pages = [
    const HomePage(),
    const PersonPage(),
    const SettingPage(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.person,
    Icons.settings,
  ];

  final List<String> _titles = [
    'Home',
    'Person',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: buildBottomNavigationBar(displayWidth, theme),
    );
  }

  Container buildBottomNavigationBar(double displayWidth, ThemeData theme) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color:
            theme.brightness == Brightness.dark ? Colors.black : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_icons.length, (index) {
          return buildNavItem(index, displayWidth, theme);
        }),
      ),
    );
  }

  Widget buildNavItem(int index, double displayWidth, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
          HapticFeedback.lightImpact();
        });
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn,
            width:
                index == currentIndex ? displayWidth * .32 : displayWidth * .18,
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.fastLinearToSlowEaseIn,
              height: index == currentIndex ? displayWidth * .12 : 0,
              width: index == currentIndex ? displayWidth * .32 : 0,
              decoration: BoxDecoration(
                color: index == currentIndex
                    ? theme.primaryColor.withOpacity(.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.fastLinearToSlowEaseIn,
            width:
                index == currentIndex ? displayWidth * .31 : displayWidth * .18,
            alignment: Alignment.center,
            child: Stack(
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == currentIndex ? displayWidth * .13 : 0,
                    ),
                    AnimatedOpacity(
                      opacity: index == currentIndex ? 1 : 0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: Text(
                        index == currentIndex ? _titles[index] : '',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: index == currentIndex ? displayWidth * .03 : 20,
                    ),
                    Icon(
                      _icons[index],
                      size: displayWidth * .076,
                      color: index == currentIndex
                          ? theme.primaryColor
                          : (theme.brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:pip_view/pip_view.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Material App',
//       home: PIPView(builder: (context, isFloting) {
//         return Scaffold(
//           floatingActionButton: FloatingActionButton(onPressed: () {
//             PIPView.of(context)?.presentBelow(const BackgroundScreen());
//           }),
//           appBar: AppBar(
//             title: const Text('Material App Bar'),
//           ),
//           body: const Center(
//             child: Text('Hello World'),
//           ),
//         );
//       }),
//     );
//   }
// }

// class BackgroundScreen extends StatelessWidget {
//   const BackgroundScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text('Holla'),
//       ),
//     );
//   }
// }









// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';

// void main() {
//   runApp(const PDFApp());
// }

// class PDFApp extends StatelessWidget {
//   const PDFApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PDF Downloader & Viewer',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const PDFDownloadPage(),
//     );
//   }
// }

// // First page with the list of available PDFs to download
// class PDFDownloadPage extends StatefulWidget {
//   const PDFDownloadPage({super.key});

//   @override
//   PDFDownloadPageState createState() => PDFDownloadPageState();
// }

// class PDFDownloadPageState extends State<PDFDownloadPage> {
//   bool isDownloading = false;
//   List<String> availablePDFs = [
//     'https://apon06.github.io/bookify_api/apon.pdf',
//     'https://apon06.github.io/bookify_api/document.pdf',
//     'https://apon06.github.io/bookify_api/hello.pdf',
//   ];
//   List<String> downloadedPDFs = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadDownloadedPDFs();
//   }

//   // Load the list of downloaded PDFs on app start
//   Future<void> _loadDownloadedPDFs() async {
//     var dir = await getApplicationDocumentsDirectory();
//     var files = dir.listSync();
//     List<String> pdfFiles = [];
//     for (var file in files) {
//       if (file.path.endsWith('.pdf')) {
//         pdfFiles.add(file.path);
//       }
//     }
//     setState(() {
//       downloadedPDFs = pdfFiles;
//     });
//   }

//   // Function to download a PDF
//   Future<void> downloadPDF(String url) async {
//     setState(() {
//       isDownloading = true;
//     });

//     try {
//       var dio = Dio();
//       var dir = await getApplicationDocumentsDirectory();
//       String fileName = url.split('/').last; // Extract file name from URL
//       String savePath = '${dir.path}/$fileName';

//       if (await File(savePath).exists()) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('PDF already downloaded!')),
//         );
//         setState(() {
//           isDownloading = false;
//         });
//         return;
//       }

//       // Download the PDF
//       await dio.download(url, savePath, onReceiveProgress: (received, total) {
//         if (total != -1) {
//           print((received / total * 100).toStringAsFixed(0) + "%");
//         }
//       });

//       setState(() {
//         downloadedPDFs.add(savePath);
//         isDownloading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('PDF downloaded successfully!')),
//       );
//     } catch (e) {
//       print(e);
//       setState(() {
//         isDownloading = false;
//       });
//     }
//   }

//   // Navigate to the offline downloads page
//   void goToOfflineDownloads() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => OfflineDownloadsPage(downloadedPDFs: downloadedPDFs),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Download PDFs'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.download),
//             onPressed: goToOfflineDownloads, // Navigate to offline downloads page
//           )
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: availablePDFs.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text('PDF ${index + 1}'),
//             trailing: isDownloading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: () => downloadPDF(availablePDFs[index]),
//                     child: const Text('Download'),
//                   ),
//           );
//         },
//       ),
//     );
//   }
// }

// // Page to show the list of downloaded PDFs and open them
// class OfflineDownloadsPage extends StatelessWidget {
//   final List<String> downloadedPDFs;

//   const OfflineDownloadsPage({super.key, required this.downloadedPDFs});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Downloaded PDFs'),
//       ),
//       body: ListView.builder(
//         itemCount: downloadedPDFs.length,
//         itemBuilder: (context, index) {
//           String filePath = downloadedPDFs[index];
//           String fileName = filePath.split('/').last;
//           return ListTile(
//             title: Text(fileName),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PDFViewPage(filePath: filePath),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// // Page to view a specific PDF
// class PDFViewPage extends StatelessWidget {
//   final String filePath;

//   const PDFViewPage({super.key, required this.filePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('View PDF'),
//       ),
//       body: PDFView(
//         filePath: filePath,
//       ),
//     );
//   }
// }
