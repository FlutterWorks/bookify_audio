// ignore_for_file: deprecated_member_use

import 'package:feedback/feedback.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      child: MaterialApp(
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
        home: const SettingPage(),
      ),
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
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  @override
  void initState() {
    super.initState();
    checkForUpdate();
    analytics.setAnalyticsCollectionEnabled(true);
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
      } else {}
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
                  'https://gokeihub.blogspot.com/p/bookify.html';

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
        setState(() async {
          await analytics.logEvent(name: "Page_track", parameters: {
            "page_index": index,
            "page_name": _titles[index],
          });
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
// import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ListView with SharedPreferences',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const NumberListPage(),
//     );
//   }
// }

// class NumberListPage extends StatefulWidget {
//   const NumberListPage({super.key});

//   @override
//   NumberListPageState createState() => NumberListPageState();
// }

// class NumberListPageState extends State<NumberListPage> {
//   // Generate a list of numbers from 1 to 100
//   List<int> numbers = List.generate(100, (index) => index + 1);
//   // List to store favorite numbers
//   List<int> favoriteNumbers = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadFavorites(); // Load saved favorites when the app starts
//   }

//   // Load favorite numbers from SharedPreferences
//   Future<void> _loadFavorites() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       favoriteNumbers = (prefs.getStringList('favorites') ?? [])
//           .map((e) => int.parse(e))
//           .toList();
//     });
//   }

//   // Save favorite numbers to SharedPreferences
//   Future<void> _saveFavorites() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList(
//         'favorites', favoriteNumbers.map((e) => e.toString()).toList());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Number List'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.favorite),
//             onPressed: () {
//               // Navigate to the Favorite Page
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FavoritePage(favoriteNumbers: favoriteNumbers, onRemove: _removeFavorite),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: numbers.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text('Number ${numbers[index]}'),
//             onTap: () {
//               setState(() {
//                 // Add to favorites if not already added
//                 if (!favoriteNumbers.contains(numbers[index])) {
//                   favoriteNumbers.add(numbers[index]);
//                   _saveFavorites(); // Save to SharedPreferences
//                 }
//               });
//             },
//           );
//         },
//       ),
//     );
//   }

//   // Method to remove an item from the favorites list and save the updated list
//   void _removeFavorite(int number) {
//     setState(() {
//       favoriteNumbers.remove(number);
//       _saveFavorites(); // Save to SharedPreferences after removing
//     });
//   }
// }

// // Favorite Page
// class FavoritePage extends StatelessWidget {
//   final List<int> favoriteNumbers;
//   final Function(int) onRemove;

//   FavoritePage({super.key, required this.favoriteNumbers, required this.onRemove});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Favorite Numbers'),
//       ),
//       body: ListView.builder(
//         itemCount: favoriteNumbers.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text('Favorite Number ${favoriteNumbers[index]}'),
//             onLongPress: () {
//               // Remove item from the list on long press
//               onRemove(favoriteNumbers[index]);
//               Navigator.pop(context); // Return to previous screen after removing
//             },
//           );
//         },
//       ),
//     );
//   }
// }
