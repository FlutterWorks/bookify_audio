// // import 'package:assets_audio_player/assets_audio_player.dart';
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:flutter/material.dart';
// // import 'package:miniplayer/miniplayer.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Audio Player App',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: AudioPlayerPage(),
// //     );
// //   }
// // }

// // class AudioPlayerPage extends StatefulWidget {
// //   @override
// //   _AudioPlayerPageState createState() => _AudioPlayerPageState();
// // }

// // class _AudioPlayerPageState extends State<AudioPlayerPage> {
// //   Map<String, dynamic> currentEpisode = {};
// //   List<Map<String, dynamic>> episodes = [
// //     {
// //       'audio_url': 'dQw4w9WgXcQ',
// //       'bookName': 'Book 1',
// //       'bookCreatorName': 'Author 1',
// //       'voiceOwner': 'Voice1',
// //       'bookImage': 'https://picsum.photos/200',
// //     },
// //     {
// //       'audio_url': 'xvFZjo5PgG0',
// //       'bookName': 'Book 2',
// //       'bookCreatorName': 'Author 2',
// //       'voiceOwner': 'Voice2',
// //       'bookImage': 'https://picsum.photos/201',
// //     },
// //     // Add more episodes as needed
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     if (episodes.isNotEmpty) {
// //       currentEpisode = episodes[0];
// //     }
// //   }

// //   void _onEpisodeChange(Map<String, dynamic> newEpisode) {
// //     setState(() {
// //       currentEpisode = newEpisode;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Audio Player'),
// //       ),
// //       body: Stack(
// //         children: [
// //           ListView.builder(
// //             itemCount: episodes.length,
// //             itemBuilder: (context, index) {
// //               final episode = episodes[index];
// //               return ListTile(
// //                 leading: Image.network(episode['bookImage']),
// //                 title: Text(episode['bookName']),
// //                 subtitle: Text(episode['bookCreatorName']),
// //                 onTap: () => _onEpisodeChange(episode),
// //               );
// //             },
// //           ),
// //           Positioned(
// //             left: 0,
// //             right: 0,
// //             bottom: 0,
// //             child: MiniPlayerWidget(
// //               currentEpisode: currentEpisode,
// //               onTap: () {
// //                 // Handle tap on mini player
// //               },
// //               onEpisodeChange: _onEpisodeChange,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class MiniPlayerWidget extends StatefulWidget {
// //   final Map<String, dynamic> currentEpisode;
// //   final VoidCallback onTap;
// //   final Function(Map<String, dynamic>) onEpisodeChange;

// //   const MiniPlayerWidget({
// //     Key? key,
// //     required this.currentEpisode,
// //     required this.onTap,
// //     required this.onEpisodeChange,
// //   }) : super(key: key);

// //   @override
// //   State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
// // }

// // class _MiniPlayerWidgetState extends State<MiniPlayerWidget> with WidgetsBindingObserver {

// //   static final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();
// //   bool _isLoading = true;
// //   double _playbackSpeed = 1.0;
// //   Duration _duration = Duration.zero;
// //   bool isPlaying = false;
// //   Duration _position = Duration.zero;
// //   late SharedPreferences _prefs;
// //   Map<String, dynamic>? _previousEpisode;
// //   double currentSliderValue = 0.0;

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addObserver(this);
// //     _initializePlayer();
// //   }

// //   @override
// //   void didUpdateWidget(MiniPlayerWidget oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (widget.currentEpisode != oldWidget.currentEpisode) {
// //       _previousEpisode = oldWidget.currentEpisode;
// //       _initializePlayer();
// //     }
// //   }

// //   Future<void> _initializePlayer() async {
// //     _prefs = await SharedPreferences.getInstance();
// //     try {
// //       setState(() {
// //         _isLoading = true;
// //       });

// //       if (_previousEpisode != null) {
// //         await _audioPlayer.stop();
// //       }

// //       final youtube = YoutubeExplode();
// //       final videoId = widget.currentEpisode['audio_url'];
// //       final manifest = await youtube.videos.streams.getManifest(videoId);
// //       final streamInfo = manifest.audioOnly.withHighestBitrate();
// //       final audioUrl = streamInfo.url.toString();

// //       final lastPosition =
// //           _prefs.getInt('lastPosition_${widget.currentEpisode['audio_url']}') ??
// //               0;

// //       await _audioPlayer.open(
// //         Audio.network(
// //           audioUrl,
// //           metas: Metas(
// //             title: widget.currentEpisode['audio_url'],
// //             artist: widget.currentEpisode['bookCreatorName'],
// //             album: widget.currentEpisode['voiceOwner'],
// //             image: MetasImage.network(widget.currentEpisode['bookImage']),
// //           ),
// //         ),
// //         autoStart: false,
// //         showNotification: true,
// //         notificationSettings: const NotificationSettings(),
// //         playInBackground: PlayInBackground.enabled,
// //         seek: Duration(seconds: lastPosition),
// //       );

// //       _audioPlayer.current.listen((playingAudio) {
// //         setState(() {
// //           _duration = playingAudio?.audio.duration ?? Duration.zero;
// //         });
// //       });

// //       _audioPlayer.currentPosition.listen((position) {
// //         setState(() {
// //           _position = position;
// //           currentSliderValue = _position.inSeconds.toDouble();
// //         });
// //         _savePosition();
// //       });

// //       await _audioPlayer.play();
// //       setState(() {
// //         isPlaying = true;
// //         _isLoading = false;
// //       });
// //     } catch (e) {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }

// //   void _savePosition() {
// //     _prefs.setInt('lastPosition_${widget.currentEpisode['audio_url']}',
// //         _position.inSeconds);
// //   }

// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) {
// //     if (state == AppLifecycleState.paused) {
// //       _savePosition();
// //     }
// //   }

// //   void _playPause() {
// //     try {
// //       setState(() {
// //         if (isPlaying) {
// //           _audioPlayer.pause();
// //         } else {
// //           _audioPlayer.play();
// //         }
// //         isPlaying = !isPlaying;
// //       });
// //     } catch (e) {
// //       // Handle error
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     WidgetsBinding.instance.removeObserver(this);
// //     super.dispose();
// //   }

// //   void _undo() {
// //     final newPosition = _position - const Duration(seconds: 10);
// //     _audioPlayer
// //         .seek(newPosition > Duration.zero ? newPosition : Duration.zero);
// //   }

// //   void _redo() {
// //     final newPosition = _position + const Duration(seconds: 10);
// //     _audioPlayer.seek(newPosition < _duration ? newPosition : _duration);
// //   }

// //   String _formatDuration(Duration duration) {
// //     String twoDigits(int n) => n.toString().padLeft(2, "0");
// //     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
// //     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
// //     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Miniplayer(
// //       minHeight: 70,
// //       maxHeight: MediaQuery.of(context).size.height,
// //       builder: (height, percentage) {
// //         if (percentage < 0.2) {
// //           return GestureDetector(
// //             onTap: widget.onTap,
// //             child: Row(
// //               children: [
// //                 Image.network(
// //                   widget.currentEpisode['bookImage'],
// //                   width: 70,
// //                   height: 70,
// //                   fit: BoxFit.cover,
// //                 ),
// //                 Expanded(
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           widget.currentEpisode['bookName'],
// //                           style: const TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                         Text(
// //                           widget.currentEpisode['audio_url'],
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   onPressed: _playPause,
// //                   icon: Icon(
// //                     isPlaying ? Icons.pause : Icons.play_arrow,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }
// //         return Padding(
// //           padding: const EdgeInsets.all(10),
// //           child: SingleChildScrollView(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.start,
// //               children: [
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(15),
// //                     boxShadow: const [
// //                       BoxShadow(
// //                         color: Colors.black26,
// //                         spreadRadius: 1,
// //                         blurRadius: 5,
// //                       ),
// //                     ],
// //                   ),
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(15),
// //                     child: CachedNetworkImage(
// //                       imageUrl: widget.currentEpisode['bookImage'],
// //                       placeholder: (context, url) =>
// //                           const CircularProgressIndicator(),
// //                       errorWidget: (context, url, error) =>
// //                           const Icon(Icons.error),
// //                       fit: BoxFit.fill,
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Text(
// //                   widget.currentEpisode['bookName'],
// //                   style: const TextStyle(
// //                     fontSize: 24,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Text(
// //                   widget.currentEpisode['bookCreatorName'],
// //                   style: const TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Column(
// //                   children: [
// //                     Slider(
// //                       value: currentSliderValue,
// //                       min: 0,
// //                       max: _duration.inSeconds.toDouble(),
// //                       onChanged: (double value) {
// //                         setState(() {
// //                           currentSliderValue = value;
// //                         });
// //                         _audioPlayer.seek(Duration(seconds: value.toInt()));
// //                       },
// //                     ),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                       children: [
// //                         Text(_formatDuration(_position)),
// //                         Text(_formatDuration(_duration)),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 20),
// //                     Center(
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         crossAxisAlignment: CrossAxisAlignment.center,
// //                         children: [
// //                           DropdownButton<double>(
// //                             value: _playbackSpeed,
// //                             items: const [
// //                               DropdownMenuItem(
// //                                   value: 0.25, child: Text('0.25x')),
// //                               DropdownMenuItem(value: 0.5, child: Text('0.5x')),
// //                               DropdownMenuItem(value: 0.75, child: Text('0.75x')),
// //                               DropdownMenuItem(value: 1.0, child: Text('1.0x')),
// //                               DropdownMenuItem(value: 1.25, child: Text('1.25x')),
// //                               DropdownMenuItem(value: 1.5, child: Text('1.5x')),
// //                               DropdownMenuItem(value: 1.75, child: Text('1.75x')),
// //                               DropdownMenuItem(value: 2.0, child: Text('2.0x')),
// //                             ],
// //                             onChanged: (double? newValue) {
// //                               if (newValue != null) {
// //                                 setState(() {
// //                                   _playbackSpeed = newValue;
// //                                   _audioPlayer.setPlaySpeed(newValue);
// //                                 });
// //                               }
// //                             },
// //                             hint: const Text('Playback Speed'),
// //                           ),
// //                           const SizedBox(width: 10),
// //                           IconButton(
// //                             onPressed: _playPause,
// //                             icon: Icon(
// //                               isPlaying ? Icons.pause : Icons.play_arrow,
// //                             ),
// //                           ),
// //                           IconButton(
// //                             onPressed: _undo,
// //                             icon: const Icon(Icons.replay_10),
// //                           ),
// //                           IconButton(
// //                             onPressed: _redo,
// //                             icon: const Icon(Icons.forward_10),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 20),
// //                 GestureDetector(
// //                   onTap: () async {
// //                     final String youtubeUrl =
// //                         'https://www.youtube.com/@${widget.currentEpisode['voiceOwner']}';
// //                     final String httpsRemove =
// //                         youtubeUrl.replaceAll('https:', 'vnd.youtube://');
// //                     final Uri youtubeAppUrl = Uri.parse(httpsRemove);
// //                     final Uri webUrl = Uri.parse(youtubeUrl);

// //                     if (await canLaunch(youtubeAppUrl.toString())) {
// //                       await launch(youtubeAppUrl.toString());
// //                     } else {
// //                       await launch(webUrl.toString());
// //                     }
// //                   },
// //                   child: Container(
// //                     height: 50,
// //                     width: 200,
// //                     decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         boxShadow: const [
// //                           BoxShadow(
// //                             color: Colors.black54,
// //                             spreadRadius: 1,
// //                             blurRadius: 5,
// //                           ),
// //                         ],
// //                         borderRadius: BorderRadius.circular(150)),
// //                     child: const Center(
// //                       child: Text(
// //                         'Subscribe The Voice Owner',
// //                         style: TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.black,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
