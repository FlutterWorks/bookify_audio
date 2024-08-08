import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test/page/Home/screen/home_page.dart';
import 'package:test/page/person/screen/person_page.dart';
import 'package:test/page/setting/screen/setting_page.dart';

void main() {
  runApp(
    const MyApp(),
  );
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
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white70),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const StartPage(),
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

  // ignore: non_constant_identifier_names
  Container buildBottomNavigationBar(double displayWidth, ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(displayWidth * .05),
      height: displayWidth * .155,
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
        borderRadius: BorderRadius.circular(50),
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
