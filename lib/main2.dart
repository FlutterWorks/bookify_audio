// ignore_for_file: deprecated_member_use

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:search_page/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
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
            SliderImageUtils(),
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



class HomePageListWidget extends StatefulWidget {
  final String api;
  final String bookImage;
  final String bookCreatorName;
  final String bookName;
  final String saveKey;
  const HomePageListWidget({
    super.key,
    required this.api,
    required this.bookImage,
    required this.bookCreatorName,
    required this.bookName,
    required this.saveKey,
  });

  @override
  State<HomePageListWidget> createState() => _HomePageListWidgetState();
}

class _HomePageListWidgetState extends State<HomePageListWidget> {
  List<dynamic> data = [];
  String bookType = '';

  Future<void> loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? savedValue = sharedPreferences.getStringList(widget.saveKey);
    String? bookTypeSaveValue =
        sharedPreferences.getString("${widget.saveKey}_bookType");
    if (savedValue != null && bookTypeSaveValue != null) {
      setState(() {
        data = savedValue.map((e) => json.decode(e)).toList();
        bookType = json.decode(bookTypeSaveValue);
      });
    }
  }

  Future<void> fetchData() async {
    var res = await http.get(Uri.parse(widget.api));
    if (res.statusCode == 200) {
      var decodedData = json.decode(res.body);
      var datad = decodedData['audiobooks'];
      var bookTyped = decodedData['bookType'];

      setState(() {
        data = datad;
        bookType = bookTyped;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setStringList(
          widget.saveKey, data.map((e) => json.encode(e)).toList());
      sharedPreferences.setString(
          "${widget.saveKey}_bookType", json.encode(bookType));
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = (screenWidth - 40) / 3;
    final double imageHeight = imageWidth * 1.5;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                bookType,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (b) => SeeMorePage(
                        api: widget.api,
                        bookImage: widget.bookImage,
                        bookName: widget.bookName,
                        bookCreatorName: widget.bookCreatorName,
                        saveKey: widget.saveKey,
                      ),
                    ),
                  );
                },
                child: const AutoSizeText(
                  'See More',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: imageHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                dynamic book = data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (builder) =>
                              EpisodeListPage(audiobook: book),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: book[widget.bookImage].toString(),
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: imageWidth,
                            height: imageHeight,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: imageWidth,
                            height: imageHeight,
                            color: Colors.grey[200],
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



class SeeMorePage extends StatelessWidget {
  final String api;
  final String bookImage;
  final String saveKey;
  final String bookName;
  final String bookCreatorName;
  const SeeMorePage({
    super.key,
    required this.api,
    required this.bookImage,
    required this.bookName,
    required this.bookCreatorName,
    required this.saveKey,
  });

  @override
  Widget build(BuildContext context) {
    return SeeMoreListWidget(
      api: api,
      bookImage: bookImage,
      bookName: bookName,
      bookCreatorName: bookCreatorName,
      saveKey: saveKey,
    );
  }
}




class SeeMoreListWidget extends StatefulWidget {
  final String api;
  final String bookImage;
  final String bookName;
  final String bookCreatorName;
  final String saveKey;
  const SeeMoreListWidget({
    super.key,
    required this.api,
    required this.bookImage,
    required this.bookName,
    required this.bookCreatorName,
    required this.saveKey,
  });

  @override
  State<SeeMoreListWidget> createState() => _SeeMoreListWidgetState();
}

class _SeeMoreListWidgetState extends State<SeeMoreListWidget> {
  List<dynamic> data = [];
  String bookType = '';

  Future<void> loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? savedValue = sharedPreferences.getStringList(widget.saveKey);
    String? bookTypeSaveValue =
        sharedPreferences.getString("${widget.saveKey}_bookType");
    if (savedValue != null && bookTypeSaveValue != null) {
      setState(() {
        data = savedValue.map((e) => json.decode(e)).toList();
        bookType = json.decode(bookTypeSaveValue);
      });
    }
  }

  Future<void> fetchData() async {
    var res = await http.get(Uri.parse(widget.api));
    if (res.statusCode == 200) {
      var decodedData = json.decode(res.body);
      var datad = decodedData['audiobooks'];
      var bookTyped = decodedData['bookType'];

      setState(() {
        data = datad;
        bookType = bookTyped;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setStringList(
          widget.saveKey, data.map((e) => json.encode(e)).toList());
      sharedPreferences.setString(
          "${widget.saveKey}_bookType", json.encode(bookType));
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          bookType,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          var book = data[index];
          return Padding(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (b) => EpisodeListPage(
                      audiobook: book,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                child: SizedBox(
                  height: 135,
                  width: MediaQuery.of(context).size.width * .99,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 120,
                                width: 100,
                                child: CachedNetworkImage(
                                  imageUrl: book[widget.bookImage],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("নাম: ${book[widget.bookName]}"),
                                  Text('লেখক: ${book[widget.bookCreatorName]}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class EpisodeListPage extends StatelessWidget {
  final dynamic audiobook;

  const EpisodeListPage({super.key, required this.audiobook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          audiobook['bookName'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: audiobook['bookImage'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'নাম: ${audiobook['bookName']}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'লেখক: ${audiobook['bookCreatorName']}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final episode = audiobook['episodes'][index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        episode['bookName'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.navigate_next,
                        color: Colors.deepPurple,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioPlayerScreen(
                              episode: episode,
                              bookName: audiobook['bookName'],
                              bookCreatorName: audiobook['bookCreatorName'],
                              bookImage: audiobook['bookImage'],
                              audioUrl: episode['audio_url'],
                              voiceOwner: episode['voice_owner'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              childCount: audiobook['episodes'].length,
            ),
          ),
        ],
      ),
    );
  }
}


const QuickActions quickActions = QuickActions();

initializeAction(BuildContext context) {
  quickActions.initialize((String shortvutType) {
    switch (shortvutType) {
      case 'HomePage':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (builder) => const HomePage()));
        return;
      case 'Writer':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (builder) => const PersonPage()));
        return;
      default:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (builder) => const SettingPage(),
          ),
        );
        return;
    }
  });
  quickActions.setShortcutItems(
    [
      const ShortcutItem(type: 'HomePage', localizedTitle: 'HomePage'),
      const ShortcutItem(
          type: 'Writer', localizedTitle: 'Writer', icon: 'person'),
      const ShortcutItem(
          type: 'Setting', localizedTitle: 'Setting', icon: 'settings'),
    ],
  );
}




class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  List<dynamic> personList = [];
  bool isLoading = true;
  dynamic selectedPerson;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> getData() async {
    final res = await http.get(
      Uri.parse('https://apon06.github.io/bookify_api/person_api.json'),
    );
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      if (mounted) {
        setState(() {
          personList = decoded['personInfo'];
          isLoading = false;
          selectedPerson = personList.isNotEmpty ? personList[0] : null;
        });
      }
      await saveDataToPreferences();
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> saveDataToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('personSave', json.encode(personList));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('personSave');
    if (savedData != null && mounted) {
      setState(() {
        personList = json.decode(savedData);
        selectedPerson = personList.isNotEmpty ? personList[0] : null;
        isLoading = false;
      });
    }
    await getData();
  }

  Future<void> refreshData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: personList.length,
                    itemBuilder: (context, index) {
                      dynamic person = personList[index];
                      return GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              selectedPerson = person;
                            });
                          }
                        },
                        child: SizedBox(
                          height: 55,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: AutoSizeText(
                                  person['personName'],
                                  maxLines: 1,
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                VerticalDivider(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                selectedPerson != null
                    ? Expanded(
                        child: PersonInfoPage(
                          personImage: selectedPerson['personImage'],
                          personName: selectedPerson['personName'],
                          personBirth: selectedPerson['personBirth'],
                          personDeath: selectedPerson['personDeath'],
                          personBio: selectedPerson['personBio'],
                          personBook: selectedPerson['personBook'],
                          personWiki: selectedPerson['personWiki'],
                        ),
                      )
                    : const Expanded(
                        child: Center(
                          child: Text('No person selected'),
                        ),
                      ),
              ],
            ),
    );
  }
}

class PersonInfoPage extends StatelessWidget {
  final String personImage;
  final String personName;
  final String personBirth;
  final String personDeath;
  final String personBio;
  final String personBook;
  final String? personWiki;

  const PersonInfoPage({
    super.key,
    required this.personImage,
    required this.personName,
    required this.personBirth,
    required this.personDeath,
    required this.personBio,
    required this.personBook,
    this.personWiki,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: CachedNetworkImageProvider(personImage),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                personName,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'জন্ম তারিখ:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(personBirth),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'মৃত্যুর তারিখ:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(personDeath.isEmpty ? 'জীবিত' : personDeath),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'জীবনী:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              personBio,
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'বিখ্যাত বই',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              personBook,
              style: const TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}


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
         
        ],
      ),
    );
  }
}

class AppInformationPage extends StatefulWidget {
  const AppInformationPage({super.key});

  @override
  State<AppInformationPage> createState() => _AppInformationPageState();
}

class _AppInformationPageState extends State<AppInformationPage> {
  String version = "";
  String appName = "";
  String packageName = "";

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String versionNumber = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    setState(() {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = '$versionNumber+$buildNumber';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Information"),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text('App Version'),
              trailing: Text(version.toString()),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('App Name'),
              trailing: Text(appName.toString()),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Package Name'),
              trailing: Text(packageName.toString()),
            ),
          ),
        ],
      ),
    );
  }
}



class AboutBookify extends StatelessWidget {
  const AboutBookify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Bookify"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: CachedNetworkImage(
                      imageUrl: "https://i.postimg.cc/KYHd794P/app-icon.jpg",
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Bookify Audio",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("© 2024 Md Apon Ahmed"),
                const SizedBox(height: 15),
                const TextButtonWidget(
                    text: "Gokei Hub", url: 'https://gokeihub.blogspot.com/'),
                const SizedBox(height: 15),
                const Text(
                  "Bookify Audio is free, open-source app where you Play Audio Book you need. Which you can use very easily",
                ),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Auther",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Row(
                  children: [
                    Text("Md Apon Ahmed"),
                    TextButtonWidget(
                      text: "apon06",
                      url: 'https://github.com/apon06',
                    ),
                  ],
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButtonWidget(
                        text: "HomePage",
                        url: 'https://gokeihub.blogspot.com/',
                      ),
                      TextButtonWidget(
                        text: "Source Code (Github)",
                        url: 'https://github.com/apon06/bookify_audio',
                      ),
                       TextButtonWidget(
                        text: "Bookify Audio Api",
                        url: 'https://github.com/apon06/bookify_api',
                      ),
                      TextButtonWidget(
                        text: "License",
                        url:
                            'https://github.com/apon06/bookify_audio/blob/main/LICENSE',
                      ),
                      TextButtonWidget(
                        text: "CHANGELOG",
                        url:
                            'https://github.com/apon06/bookify_audio/blob/main/CHANGELOG.md',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class TextButtonWidget extends StatelessWidget {
  final String text;
  final String url;
  const TextButtonWidget({
    super.key,
    required this.text,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          String privacyUrl = url.toString();
          final Uri uri = Uri.parse(privacyUrl);
          if (await canLaunch(uri.toString())) {
            await launch(uri.toString());
          } else {
            await launch(uri.toString());
          }
        },
        child: Text(text));
  }
}
class ChangeLogPage extends StatefulWidget {
  const ChangeLogPage({super.key});

  @override
  ChangeLogPageState createState() => ChangeLogPageState();
}

class ChangeLogPageState extends State<ChangeLogPage> {
  String markdownData = '';

  @override
  void initState() {
    super.initState();
    loadMarkdown();
  }

  void loadMarkdown() async {
    String data = await rootBundle.loadString('CHANGELOG.md');
    setState(() {
      markdownData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chanage History'),
      ),
      body: Markdown(
        data: markdownData,
      ),
    );
  }
}




class AudioPlayerScreen extends StatefulWidget {
  final dynamic episode;
  final String bookName;
  final String bookCreatorName;
  final String bookImage;
  final String audioUrl;
  final String voiceOwner;
  const AudioPlayerScreen({
    super.key,
    this.episode,
    required this.bookName,
    required this.bookCreatorName,
    required this.bookImage,
    required this.audioUrl,
    required this.voiceOwner,
  });

  @override
  AudioPlayerScreenState createState() => AudioPlayerScreenState();
}

class AudioPlayerScreenState extends State<AudioPlayerScreen>
    with WidgetsBindingObserver {
  late AssetsAudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = true;
  double _currentSliderValue = 0;
  double _playbackSpeed = 1.0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AssetsAudioPlayer();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        _isLoading = true;
      });

      final youtube = YoutubeExplode();
      final videoId = widget.audioUrl;
      final manifest = await youtube.videos.streams.getManifest(videoId);
      final streamInfo = manifest.audioOnly.withHighestBitrate();
      final audioUrl = streamInfo.url.toString();

      final lastPosition =
          _prefs.getInt('lastPosition_${widget.audioUrl}') ?? 0;

      await _audioPlayer.open(
        Audio.network(
          audioUrl,
          metas: Metas(
            title: widget.bookName,
            artist: widget.bookCreatorName,
            album: widget.voiceOwner,
            image: MetasImage.network(widget.bookImage),
          ),
        ),
        autoStart: false,
        showNotification: true,
        notificationSettings: const NotificationSettings(),
        playInBackground: PlayInBackground.enabled,
        seek: Duration(seconds: lastPosition),
      );

      _audioPlayer.current.listen((playingAudio) {
        setState(() {
          _duration = playingAudio?.audio.duration ?? Duration.zero;
        });
      });

      _audioPlayer.currentPosition.listen((position) {
        setState(() {
          _position = position;
          _currentSliderValue = _position.inSeconds.toDouble();
        });
        _savePosition();
      });

      await _audioPlayer.play();
      setState(() {
        _isPlaying = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _savePosition() {
    _prefs.setInt('lastPosition_${widget.audioUrl}', _position.inSeconds);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _savePosition();
    }
  }

  void _playPause() {
    try {
      setState(() {
        if (_isPlaying) {
          _audioPlayer.pause();
        } else {
          _audioPlayer.play();
        }
        _isPlaying = !_isPlaying;
      });
    } catch (e) {
      // Handle error
    }
  }

  void _undo() {
    final newPosition = _position - const Duration(seconds: 10);
    _audioPlayer
        .seek(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  void _redo() {
    final newPosition = _position + const Duration(seconds: 10);
    _audioPlayer.seek(newPosition < _duration ? newPosition : _duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.bookName)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: widget.bookImage,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.bookName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.bookCreatorName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Slider(
                          value: _currentSliderValue,
                          min: 0,
                          max: _duration.inSeconds.toDouble(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(_formatDuration(_position)),
                            Text(_formatDuration(_duration)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DropdownButton<double>(
                                value: _playbackSpeed,
                                items: const [
                                  DropdownMenuItem(
                                      value: 0.25, child: Text('0.25x')),
                                  DropdownMenuItem(
                                      value: 0.5, child: Text('0.5x')),
                                  DropdownMenuItem(
                                      value: 0.6, child: Text('0.6x')),
                                  DropdownMenuItem(
                                      value: 0.75, child: Text('0.75x')),
                                  DropdownMenuItem(
                                      value: 1.0, child: Text('1.0x')),
                                  DropdownMenuItem(
                                      value: 1.25, child: Text('1.25x')),
                                  DropdownMenuItem(
                                      value: 1.4, child: Text('1.4x')),
                                  DropdownMenuItem(
                                      value: 1.5, child: Text('1.5x')),
                                  DropdownMenuItem(
                                      value: 1.75, child: Text('1.75x')),
                                  DropdownMenuItem(
                                      value: 2.0, child: Text('2.0x')),
                                  DropdownMenuItem(
                                      value: 2.5, child: Text('2.5x')),
                                  DropdownMenuItem(
                                      value: 3.0, child: Text('3.0x')),
                                  DropdownMenuItem(
                                      value: 3.5, child: Text('3.5x')),
                                  DropdownMenuItem(
                                      value: 4.0, child: Text('4.0x')),
                                  DropdownMenuItem(
                                      value: 4.5, child: Text('4.5x')),
                                  DropdownMenuItem(
                                      value: 5.0, child: Text('5.0x')),
                                  DropdownMenuItem(
                                      value: 5.5, child: Text('5.5x')),
                                  DropdownMenuItem(
                                      value: 6.0, child: Text('6.0x')),
                                ],
                                onChanged: (double? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _playbackSpeed = newValue;
                                      _audioPlayer.setPlaySpeed(newValue);
                                    });
                                  }
                                },
                                hint: const Text('Playback Speed'),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: _playPause,
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                ),
                              ),
                              IconButton(
                                onPressed: _undo,
                                icon: const Icon(Icons.replay_10),
                              ),
                              IconButton(
                                onPressed: _redo,
                                icon: const Icon(Icons.forward_10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final String youtubeUrl =
                            'https://www.youtube.com/@${widget.voiceOwner}';
                        final String httpsRemove =
                            youtubeUrl.replaceAll('https:', 'vnd.youtube://');
                        final Uri youtubeAppUrl = Uri.parse(httpsRemove);
                        final Uri webUrl = Uri.parse(youtubeUrl);

                        if (await canLaunch(youtubeAppUrl.toString())) {
                          await launch(youtubeAppUrl.toString());
                        } else {
                          await launch(webUrl.toString());
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(150)),
                        child: const Center(
                          child: Text(
                            'Subscribe The Voice Owner',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.dispose();
  }
}



class AppBarUtil extends StatelessWidget {
  const AppBarUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SearchBarUils(),
      ],
    );
  }
}



class SearchBarUils extends StatefulWidget {
  const SearchBarUils({super.key});

  @override
  State<SearchBarUils> createState() =>
      _SearchBarUilsState();
}

class _SearchBarUilsState extends State<SearchBarUils> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> getData() async {
    try {
      final res = await http.get(
        Uri.parse('https://apon06.github.io/bookify_api/writer/rabindranath_thakur.json'),
      );
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        setState(() {
          data = List<Map<String, dynamic>>.from(decoded['audiobooks']);
          isLoading = false;
        });
        await saveDataToPreferences();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveDataToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('save', json.encode(data));
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('save');

    if (savedData != null) {
      setState(() {
        data = List<Map<String, dynamic>>.from(json.decode(savedData));
        isLoading = false;
      });
    }
    await getData();
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (data.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'No data available. Please check your internet connection and try again.')),
          );
          return;
        }
        showSearch(
          context: context,
          delegate: SearchPage<Map<String, dynamic>>(
            failure: const Center(
              child: Text('No App found :('),
            ),
            searchLabel: 'Search App',
            builder: (builder) {
              dynamic book = builder;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (b) => EpisodeListPage(
                          audiobook: book,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    child: SizedBox(
                      height: 135,
                      width: MediaQuery.of(context).size.width * .99,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    height: 120,
                                    width: 100,
                                    child: CachedNetworkImage(
                                      imageUrl: builder['bookImage'].toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "নাম: ${builder['bookName'].toString()}"),
                                      Text(
                                          'লেখক: ${builder['bookCreatorName'].toString()}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            filter: (filter) => [
              filter['bookName'].toString(),
              filter['bookNameEn'].toString(),
            ],
            items: data,
          ),
        );
      },
      child: const Padding(
        padding: EdgeInsets.only(right: 5),
        child: SizedBox(
          width: 50,
          child: Icon(Icons.search),
        ),
      ),
    );
  }
}

class WriterUtils extends StatefulWidget {
  const WriterUtils({super.key});

  @override
  State<WriterUtils> createState() => _WriterUtilsState();
}

class _WriterUtilsState extends State<WriterUtils> {
  List<dynamic> writerList = [];
  bool isLoading = true;

  Future<void> getData() async {
    final res = await http.get(
      Uri.parse('https://apon06.github.io/bookify_api/writer.json'),
    );
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      setState(() {
        writerList = decoded['WriterInfo'];
        isLoading = false;
      });
      await saveDataToPreferences();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveDataToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('WriterSaveKey', json.encode(writerList));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('WriterSaveKey');
    if (savedData != null) {
      setState(() {
        writerList = json.decode(savedData);
        isLoading = false;
      });
    }
    await getData();
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await getData();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: writerList.length,
        itemBuilder: (b, index) {
          var categoryApi = writerList[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WriterDetailsPage(
                    api: categoryApi["api"],
                    bookImage: categoryApi["bookImage"],
                    bookName: categoryApi["bookName"],
                    bookCreatorName: categoryApi["bookCreatorName"],
                    saveKey: categoryApi["saveKey"],
                    writerImage: categoryApi['writerImage'],
                  ),
                ),
              ),
              child: CircleAvatar(
                radius: 75,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage:
                      CachedNetworkImageProvider(categoryApi["writerImage"]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}





class WriterDetailsPage extends StatefulWidget {
  final String api;
  final String bookImage;
  final String bookName;
  final String bookCreatorName;
  final String saveKey;
  final String writerImage;
  const WriterDetailsPage({
    super.key,
    required this.api,
    required this.bookImage,
    required this.bookName,
    required this.bookCreatorName,
    required this.saveKey,
    required this.writerImage,
  });

  @override
  State<WriterDetailsPage> createState() => _WriterDetailsPageState();
}

class _WriterDetailsPageState extends State<WriterDetailsPage> {
  List<dynamic> data = [];
  String bookType = '';

  Future<void> loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? savedValue = sharedPreferences.getStringList(widget.saveKey);
    String? bookTypeSaveValue =
        sharedPreferences.getString("${widget.saveKey}_bookType");
    if (savedValue != null && bookTypeSaveValue != null) {
      setState(() {
        data = savedValue.map((e) => json.decode(e)).toList();
        bookType = json.decode(bookTypeSaveValue);
      });
    }
  }

  Future<void> fetchData() async {
    var res = await http.get(Uri.parse(widget.api));
    if (res.statusCode == 200) {
      var decodedData = json.decode(res.body);
      var datad = decodedData['audiobooks'];
      var bookTyped = decodedData['bookType'];

      setState(() {
        data = datad;
        bookType = bookTyped;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setStringList(
          widget.saveKey, data.map((e) => json.encode(e)).toList());
      sharedPreferences.setString(
          "${widget.saveKey}_bookType", json.encode(bookType));
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    var book;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          bookType,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: 250,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: CachedNetworkImage(
              imageUrl: widget.writerImage.toString(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                book = data[index];
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (b) => EpisodeListPage(
                            audiobook: book,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      child: SizedBox(
                        height: 135,
                        width: MediaQuery.of(context).size.width * .99,
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      height: 120,
                                      width: 100,
                                      child: CachedNetworkImage(
                                        imageUrl: book[widget.bookImage],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("নাম: ${book[widget.bookName]}"),
                                        Text(
                                            'লেখক: ${book[widget.bookCreatorName]}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SliderImageUtils extends StatefulWidget {
  const SliderImageUtils({super.key});

  @override
  SliderImageUtilsState createState() => SliderImageUtilsState();
}

class SliderImageUtilsState extends State<SliderImageUtils> {
  List<dynamic> _imageList = [];

  @override
  void initState() {
    super.initState();
    _loadStoredImages();
    _fetchImages();
  }

  Future<void> _loadStoredImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedImages = prefs.getString('imageList');
    if (storedImages != null) {
      setState(() {
        _imageList = json.decode(storedImages);
      });
    }
  }

  Future<void> _fetchImages() async {
    final response = await http
        .get(Uri.parse('https://apon06.github.io/bookify_api/slider_api.json'));
    if (response.statusCode == 200) {
      setState(() {
        _imageList = json.decode(response.body);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('imageList', response.body);
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _imageList.isNotEmpty
        ? CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 16 / 9,
              enlargeCenterPage: true,
            ),
            items: _imageList.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SliderAudioPlayerScreen(
                              title: item['bookName'],
                              bookCreatorName: item['bookCreator'],
                              bookImage: item['image'],
                              audioUrl: item['audio_url'],
                              voiceOwner: item['voice_owner'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: 1000,
                            imageUrl: item['image'] ?? '',
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ));
                },
              );
            }).toList(),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class SliderAudioPlayerScreen extends StatefulWidget {
  final String title;
  final String bookCreatorName;
  final String bookImage;
  final String audioUrl;
  final String voiceOwner;
  const SliderAudioPlayerScreen({
    super.key,
    required this.title,
    required this.bookCreatorName,
    required this.bookImage,
    required this.audioUrl,
    required this.voiceOwner,
  });

  @override
  SliderAudioPlayerScreenState createState() =>
      SliderAudioPlayerScreenState();
}

class SliderAudioPlayerScreenState extends State<SliderAudioPlayerScreen>
    with WidgetsBindingObserver {
  late AssetsAudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = true;
  double _currentSliderValue = 0;
  double _playbackSpeed = 1.0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AssetsAudioPlayer();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        _isLoading = true;
      });

      final youtube = YoutubeExplode();
      final videoId = widget.audioUrl;
      final manifest = await youtube.videos.streams.getManifest(videoId);
      final streamInfo = manifest.audioOnly.withHighestBitrate();
      final audioUrl = streamInfo.url.toString();

      final lastPosition =
          _prefs.getInt('lastPosition_${widget.audioUrl}') ?? 0;

      await _audioPlayer.open(
        Audio.network(
          audioUrl,
          metas: Metas(
            title: widget.title,
            artist: widget.bookCreatorName,
            album: widget.voiceOwner,
            image: MetasImage.network(widget.bookImage),
          ),
        ),
        autoStart: false,
        showNotification: true,
        notificationSettings: const NotificationSettings(),
        playInBackground: PlayInBackground.enabled,
        seek: Duration(seconds: lastPosition),
      );

      _audioPlayer.current.listen((playingAudio) {
        setState(() {
          _duration = playingAudio?.audio.duration ?? Duration.zero;
        });
      });

      _audioPlayer.currentPosition.listen((position) {
        setState(() {
          _position = position;
          _currentSliderValue = _position.inSeconds.toDouble();
        });
        _savePosition();
      });

      await _audioPlayer.play();
      setState(() {
        _isPlaying = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _savePosition() {
    _prefs.setInt('lastPosition_${widget.audioUrl}', _position.inSeconds);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _savePosition();
    }
  }

  void _playPause() {
    try {
      setState(() {
        if (_isPlaying) {
          _audioPlayer.pause();
        } else {
          _audioPlayer.play();
        }
        _isPlaying = !_isPlaying;
      });
    } catch (e) {
      //
    }
  }

  void _undo() {
    final newPosition = _position - const Duration(seconds: 10);
    _audioPlayer
        .seek(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  void _redo() {
    final newPosition = _position + const Duration(seconds: 10);
    _audioPlayer.seek(newPosition < _duration ? newPosition : _duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: widget.bookImage,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.bookCreatorName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Slider(
                          value: _currentSliderValue,
                          min: 0,
                          max: _duration.inSeconds.toDouble(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(_formatDuration(_position)),
                            Text(_formatDuration(_duration)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DropdownButton<double>(
                                value: _playbackSpeed,
                                items: const [
                                  DropdownMenuItem(
                                      value: 0.25, child: Text('0.25x')),
                                  DropdownMenuItem(
                                      value: 0.5, child: Text('0.5x')),
                                  DropdownMenuItem(
                                      value: 0.6, child: Text('0.6x')),
                                  DropdownMenuItem(
                                      value: 0.75, child: Text('0.75x')),
                                  DropdownMenuItem(
                                      value: 1.0, child: Text('1.0x')),
                                  DropdownMenuItem(
                                      value: 1.25, child: Text('1.25x')),
                                  DropdownMenuItem(
                                      value: 1.4, child: Text('1.4x')),
                                  DropdownMenuItem(
                                      value: 1.5, child: Text('1.5x')),
                                  DropdownMenuItem(
                                      value: 1.75, child: Text('1.75x')),
                                  DropdownMenuItem(
                                      value: 2.0, child: Text('2.0x')),
                                  DropdownMenuItem(
                                      value: 2.5, child: Text('2.5x')),
                                  DropdownMenuItem(
                                      value: 3.0, child: Text('3.0x')),
                                  DropdownMenuItem(
                                      value: 3.5, child: Text('3.5x')),
                                  DropdownMenuItem(
                                      value: 4.0, child: Text('4.0x')),
                                  DropdownMenuItem(
                                      value: 4.5, child: Text('4.5x')),
                                  DropdownMenuItem(
                                      value: 5.0, child: Text('5.0x')),
                                  DropdownMenuItem(
                                      value: 5.5, child: Text('5.5x')),
                                  DropdownMenuItem(
                                      value: 6.0, child: Text('6.0x')),
                                ],
                                onChanged: (double? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _playbackSpeed = newValue;
                                      _audioPlayer.setPlaySpeed(newValue);
                                    });
                                  }
                                },
                                hint: const Text('Playback Speed'),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: _playPause,
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                ),
                              ),
                              IconButton(
                                onPressed: _undo,
                                icon: const Icon(Icons.replay_10),
                              ),
                              IconButton(
                                onPressed: _redo,
                                icon: const Icon(Icons.forward_10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final String youtubeUrl =
                            'https://www.youtube.com/@${widget.voiceOwner}';
                        final Uri uri = Uri.parse(youtubeUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Could not launch $youtubeUrl')),
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child: const Center(
                          child: Text(
                            'Subscribe The Voice Owner',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.dispose();
  }
}
class CategoryListUtils extends StatefulWidget {
  const CategoryListUtils({super.key});

  @override
  State<CategoryListUtils> createState() => _CategoryListUtilsState();
}

class _CategoryListUtilsState extends State<CategoryListUtils> {
  List<dynamic> categoryList = [];
  bool isLoading = true;

  Future<void> getData() async {
    final res = await http.get(
      Uri.parse('https://apon06.github.io/bookify_api/category.json'),
    );
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      setState(() {
        categoryList = decoded['Category'];
        isLoading = false;
      });
      await saveDataToPreferences();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveDataToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('CategorySaveKey', json.encode(categoryList));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('CategorySaveKey');
    if (savedData != null) {
      setState(() {
        categoryList = json.decode(savedData);
        isLoading = false;
      });
    }
    await getData();
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await getData();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        itemBuilder: (b, index) {
          var categoryApi = categoryList[index];
          return CategoryButtonWidget(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SeeMorePage(
                  api: categoryApi["api"],
                  bookImage: categoryApi["bookImage"],
                  bookName: categoryApi["bookName"],
                  bookCreatorName: categoryApi["bookCreatorName"],
                  saveKey: categoryApi["saveKey"],
                ),
              ),
            ),
            categoryText: categoryApi["bookType"],
            categoryColor: categoryApi["color"],
          );
        },
      ),
    );
  }
}

class CategoryButtonWidget extends StatelessWidget {
  final String? categoryText;
  final String? categoryColor;
  final Function()? onTap;
  const CategoryButtonWidget({
    super.key,
    this.categoryText = 'Book Apon',
    this.onTap,
    this.categoryColor = "#f2f2f2",
  });

  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = Theme.of(context).brightness == Brightness.dark; // not remove this
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: HexColor(categoryColor!),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 4,
              bottom: 4,
            ),
            child: AutoSizeText(
              minFontSize: 15,
              maxFontSize: 20,
              categoryText!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
