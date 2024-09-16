// ignore_for_file: deprecated_member_use

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




// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:miniplayer/miniplayer.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Audio Player App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AudioPlayerPage(),
//     );
//   }
// }

// class AudioPlayerPage extends StatefulWidget {
//   @override
//   _AudioPlayerPageState createState() => _AudioPlayerPageState();
// }

// class _AudioPlayerPageState extends State<AudioPlayerPage> {
//   Map<String, dynamic> currentEpisode = {};
//   List<Map<String, dynamic>> episodes = [
//     {
//       'audio_url': 'dQw4w9WgXcQ',
//       'bookName': 'Book 1',
//       'bookCreatorName': 'Author 1',
//       'voiceOwner': 'Voice1',
//       'bookImage': 'https://picsum.photos/200',
//     },
//     {
//       'audio_url': 'xvFZjo5PgG0',
//       'bookName': 'Book 2',
//       'bookCreatorName': 'Author 2',
//       'voiceOwner': 'Voice2',
//       'bookImage': 'https://picsum.photos/201',
//     },
//     // Add more episodes as needed
//   ];

//   @override
//   void initState() {
//     super.initState();
//     if (episodes.isNotEmpty) {
//       currentEpisode = episodes[0];
//     }
//   }

//   void _onEpisodeChange(Map<String, dynamic> newEpisode) {
//     setState(() {
//       currentEpisode = newEpisode;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Player'),
//       ),
//       body: Stack(
//         children: [
//           ListView.builder(
//             itemCount: episodes.length,
//             itemBuilder: (context, index) {
//               final episode = episodes[index];
//               return ListTile(
//                 leading: Image.network(episode['bookImage']),
//                 title: Text(episode['bookName']),
//                 subtitle: Text(episode['bookCreatorName']),
//                 onTap: () => _onEpisodeChange(episode),
//               );
//             },
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: MiniPlayerWidget(
//               currentEpisode: currentEpisode,
//               onTap: () {
//                 // Handle tap on mini player
//               },
//               onEpisodeChange: _onEpisodeChange,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MiniPlayerWidget extends StatefulWidget {
//   final Map<String, dynamic> currentEpisode;
//   final VoidCallback onTap;
//   final Function(Map<String, dynamic>) onEpisodeChange;

//   const MiniPlayerWidget({
//     Key? key,
//     required this.currentEpisode,
//     required this.onTap,
//     required this.onEpisodeChange,
//   }) : super(key: key);

//   @override
//   State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
// }

// class _MiniPlayerWidgetState extends State<MiniPlayerWidget> with WidgetsBindingObserver {

//   static final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();
//   bool _isLoading = true;
//   double _playbackSpeed = 1.0;
//   Duration _duration = Duration.zero;
//   bool isPlaying = false;
//   Duration _position = Duration.zero;
//   late SharedPreferences _prefs;
//   Map<String, dynamic>? _previousEpisode;
//   double currentSliderValue = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initializePlayer();
//   }

//   @override
//   void didUpdateWidget(MiniPlayerWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.currentEpisode != oldWidget.currentEpisode) {
//       _previousEpisode = oldWidget.currentEpisode;
//       _initializePlayer();
//     }
//   }

//   Future<void> _initializePlayer() async {
//     _prefs = await SharedPreferences.getInstance();
//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       if (_previousEpisode != null) {
//         await _audioPlayer.stop();
//       }

//       final youtube = YoutubeExplode();
//       final videoId = widget.currentEpisode['audio_url'];
//       final manifest = await youtube.videos.streams.getManifest(videoId);
//       final streamInfo = manifest.audioOnly.withHighestBitrate();
//       final audioUrl = streamInfo.url.toString();

//       final lastPosition =
//           _prefs.getInt('lastPosition_${widget.currentEpisode['audio_url']}') ??
//               0;

//       await _audioPlayer.open(
//         Audio.network(
//           audioUrl,
//           metas: Metas(
//             title: widget.currentEpisode['audio_url'],
//             artist: widget.currentEpisode['bookCreatorName'],
//             album: widget.currentEpisode['voiceOwner'],
//             image: MetasImage.network(widget.currentEpisode['bookImage']),
//           ),
//         ),
//         autoStart: false,
//         showNotification: true,
//         notificationSettings: const NotificationSettings(),
//         playInBackground: PlayInBackground.enabled,
//         seek: Duration(seconds: lastPosition),
//       );

//       _audioPlayer.current.listen((playingAudio) {
//         setState(() {
//           _duration = playingAudio?.audio.duration ?? Duration.zero;
//         });
//       });

//       _audioPlayer.currentPosition.listen((position) {
//         setState(() {
//           _position = position;
//           currentSliderValue = _position.inSeconds.toDouble();
//         });
//         _savePosition();
//       });

//       await _audioPlayer.play();
//       setState(() {
//         isPlaying = true;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _savePosition() {
//     _prefs.setInt('lastPosition_${widget.currentEpisode['audio_url']}',
//         _position.inSeconds);
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       _savePosition();
//     }
//   }

//   void _playPause() {
//     try {
//       setState(() {
//         if (isPlaying) {
//           _audioPlayer.pause();
//         } else {
//           _audioPlayer.play();
//         }
//         isPlaying = !isPlaying;
//       });
//     } catch (e) {
//       // Handle error
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   void _undo() {
//     final newPosition = _position - const Duration(seconds: 10);
//     _audioPlayer
//         .seek(newPosition > Duration.zero ? newPosition : Duration.zero);
//   }

//   void _redo() {
//     final newPosition = _position + const Duration(seconds: 10);
//     _audioPlayer.seek(newPosition < _duration ? newPosition : _duration);
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Miniplayer(
//       minHeight: 70,
//       maxHeight: MediaQuery.of(context).size.height,
//       builder: (height, percentage) {
//         if (percentage < 0.2) {
//           return GestureDetector(
//             onTap: widget.onTap,
//             child: Row(
//               children: [
//                 Image.network(
//                   widget.currentEpisode['bookImage'],
//                   width: 70,
//                   height: 70,
//                   fit: BoxFit.cover,
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.currentEpisode['bookName'],
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Text(
//                           widget.currentEpisode['audio_url'],
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: _playPause,
//                   icon: Icon(
//                     isPlaying ? Icons.pause : Icons.play_arrow,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//         return Padding(
//           padding: const EdgeInsets.all(10),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black26,
//                         spreadRadius: 1,
//                         blurRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: CachedNetworkImage(
//                       imageUrl: widget.currentEpisode['bookImage'],
//                       placeholder: (context, url) =>
//                           const CircularProgressIndicator(),
//                       errorWidget: (context, url, error) =>
//                           const Icon(Icons.error),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   widget.currentEpisode['bookName'],
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   widget.currentEpisode['bookCreatorName'],
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Column(
//                   children: [
//                     Slider(
//                       value: currentSliderValue,
//                       min: 0,
//                       max: _duration.inSeconds.toDouble(),
//                       onChanged: (double value) {
//                         setState(() {
//                           currentSliderValue = value;
//                         });
//                         _audioPlayer.seek(Duration(seconds: value.toInt()));
//                       },
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Text(_formatDuration(_position)),
//                         Text(_formatDuration(_duration)),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           DropdownButton<double>(
//                             value: _playbackSpeed,
//                             items: const [
//                               DropdownMenuItem(
//                                   value: 0.25, child: Text('0.25x')),
//                               DropdownMenuItem(value: 0.5, child: Text('0.5x')),
//                               DropdownMenuItem(value: 0.75, child: Text('0.75x')),
//                               DropdownMenuItem(value: 1.0, child: Text('1.0x')),
//                               DropdownMenuItem(value: 1.25, child: Text('1.25x')),
//                               DropdownMenuItem(value: 1.5, child: Text('1.5x')),
//                               DropdownMenuItem(value: 1.75, child: Text('1.75x')),
//                               DropdownMenuItem(value: 2.0, child: Text('2.0x')),
//                             ],
//                             onChanged: (double? newValue) {
//                               if (newValue != null) {
//                                 setState(() {
//                                   _playbackSpeed = newValue;
//                                   _audioPlayer.setPlaySpeed(newValue);
//                                 });
//                               }
//                             },
//                             hint: const Text('Playback Speed'),
//                           ),
//                           const SizedBox(width: 10),
//                           IconButton(
//                             onPressed: _playPause,
//                             icon: Icon(
//                               isPlaying ? Icons.pause : Icons.play_arrow,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: _undo,
//                             icon: const Icon(Icons.replay_10),
//                           ),
//                           IconButton(
//                             onPressed: _redo,
//                             icon: const Icon(Icons.forward_10),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: () async {
//                     final String youtubeUrl =
//                         'https://www.youtube.com/@${widget.currentEpisode['voiceOwner']}';
//                     final String httpsRemove =
//                         youtubeUrl.replaceAll('https:', 'vnd.youtube://');
//                     final Uri youtubeAppUrl = Uri.parse(httpsRemove);
//                     final Uri webUrl = Uri.parse(youtubeUrl);

//                     if (await canLaunch(youtubeAppUrl.toString())) {
//                       await launch(youtubeAppUrl.toString());
//                     } else {
//                       await launch(webUrl.toString());
//                     }
//                   },
//                   child: Container(
//                     height: 50,
//                     width: 200,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black54,
//                             spreadRadius: 1,
//                             blurRadius: 5,
//                           ),
//                         ],
//                         borderRadius: BorderRadius.circular(150)),
//                     child: const Center(
//                       child: Text(
//                         'Subscribe The Voice Owner',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
