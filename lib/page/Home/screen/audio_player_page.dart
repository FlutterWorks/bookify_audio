import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class AudioPlayerScreen extends StatefulWidget {
  final dynamic episode;
  final String title;
  final String bookCreatorName;
  final String bookImage;
  final String audioUrl;
  final String voiceOwner;
  const AudioPlayerScreen({
    super.key,
    this.episode,
    required this.title,
    required this.bookCreatorName,
    required this.bookImage,
    required this.audioUrl,
    required this.voiceOwner,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _currentSliderValue = 0;
  double _playbackSpeed = 1.0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _error;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final youtube = YoutubeExplode();
      final videoId = widget.audioUrl;
      final manifest = await youtube.videos.streams.getManifest(videoId);
      final streamInfo = manifest.audioOnly.first;
      final audioUrl = streamInfo.url.toString();

      await _audioPlayer.setUrl(audioUrl);
      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      });
      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position;
          _currentSliderValue = _position.inSeconds.toDouble();
        });
      });

      // Start playing automatically
      _audioPlayer.play();
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load audio: $e';
      });
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
      appBar: AppBar(title: Text(widget.episode['title'])),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: widget.bookImage,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                // height: 200,
                // width: 330,
                fit: BoxFit.fill,
              ),
              Text(widget.title),
              const SizedBox(height: 10),
              Text(widget.bookCreatorName),
              const SizedBox(height: 10),
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                )
              else
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
                        Text(
                          _formatDuration(_position),
                        ),
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
                              DropdownMenuItem(value: 0.25, child: Text('0.25x')),
                              DropdownMenuItem(value: 0.5, child: Text('0.5x')),
                              DropdownMenuItem(value: 0.6, child: Text('0.6x')),
                              DropdownMenuItem(value: 0.75, child: Text('0.75x')),
                              DropdownMenuItem(value: 1.0, child: Text('1.0x')),
                              DropdownMenuItem(value: 1.25, child: Text('1.25x')),
                              DropdownMenuItem(value: 1.4, child: Text('1.4x')),
                              DropdownMenuItem(value: 1.5, child: Text('1.5x')),
                              DropdownMenuItem(value: 1.75, child: Text('1.75x')),
                              DropdownMenuItem(value: 2.0, child: Text('2.0x')),
                              DropdownMenuItem(value: 2.5, child: Text('2.5x')),
                              DropdownMenuItem(value: 3.0, child: Text('3.0x')),
                              DropdownMenuItem(value: 3.5, child: Text('3.5x')),
                              DropdownMenuItem(value: 4.0, child: Text('4.0x')),
                              DropdownMenuItem(value: 4.5, child: Text('4.5x')),
                              DropdownMenuItem(value: 5.0, child: Text('5.0x')),
                              DropdownMenuItem(value: 5.5, child: Text('5.5x')),
                              DropdownMenuItem(value: 6.0, child: Text('6.0x')),
                            ],
                            onChanged: (double? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _playbackSpeed = newValue;
                                  _audioPlayer.setSpeed(newValue);
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
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  final String youtubeUrl = widget.voiceOwner;
                  final String httpsRemove =
                      youtubeUrl.replaceAll('https:', 'vnd.youtube://');
                  final Uri youtubeAppUrl = Uri.parse(httpsRemove);
                  final Uri webUrl = Uri.parse(youtubeUrl);
          
                  // ignore: deprecated_member_use
                  if (await canLaunch(youtubeAppUrl.toString())) {
                    // ignore: deprecated_member_use
                    await launch(youtubeAppUrl.toString());
                  } else {
                    // ignore: deprecated_member_use
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
                    child: Text('Subscribe The Voice Owner'),
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
    _audioPlayer.dispose();
    super.dispose();
  }
}







// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_cache/just_audio_cache.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class AudioPlayerScreen extends StatefulWidget {
//   final dynamic episode;
//   final String title;
//   final String bookCreatorName;
//   final String bookImage;
//   final String audioUrl;

//   const AudioPlayerScreen({
//     Key? key,
//     this.episode,
//     required this.title,
//     required this.bookCreatorName,
//     required this.bookImage,
//     required this.audioUrl,
//   }) : super(key: key);

//   @override
//   _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
// }

// class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
//   late AudioPlayer _audioPlayer;
//   late AudioCache _audioCache;
//   bool _isPlaying = false;
//   bool _isDownloaded = false;
//   double _currentSliderValue = 0;
//   double _playbackSpeed = 1.0;
//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     _initializePlayer();
//   }

//   Future<void> _initializePlayer() async {
//     try {
//       final appDocDir = await getApplicationDocumentsDirectory();
//       final cacheDir = Directory('${appDocDir.path}/audio_cache');
//       _audioCache = AudioCache(cacheDir: cacheDir);

//       final cachedFile = await _audioCache.load(widget.audioUrl);
//       if (cachedFile != null) {
//         setState(() {
//           _isDownloaded = true;
//         });
//         await _audioPlayer.setFilePath(cachedFile.path);
//       } else {
//         final youtube = YoutubeExplode();
//         final videoId = widget.audioUrl;
//         final manifest = await youtube.videos.streams.getManifest(videoId);
//         final streamInfo = manifest.audioOnly.first;
//         final audioUrl = streamInfo.url.toString();

//         await _audioPlayer.setUrl(audioUrl);
//       }

//       _audioPlayer.durationStream.listen((duration) {
//         setState(() {
//           _duration = duration ?? Duration.zero;
//         });
//       });
//       _audioPlayer.positionStream.listen((position) {
//         setState(() {
//           _position = position;
//           _currentSliderValue = _position.inSeconds.toDouble();
//         });
//       });

//       // Start playing automatically
//       _audioPlayer.play();
//       setState(() {
//         _isPlaying = true;
//       });
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to load audio: $e';
//       });
//     }
//   }

//   Future<void> _downloadAudio() async {
//     try {
//       final youtube = YoutubeExplode();
//       final videoId = widget.audioUrl;
//       final manifest = await youtube.videos.streams.getManifest(videoId);
//       final streamInfo = manifest.audioOnly.first;
//       final audioUrl = streamInfo.url.toString();

//       await _audioCache.load(audioUrl);
//       setState(() {
//         _isDownloaded = true;
//       });
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to download audio: $e';
//       });
//     }
//   }

//   void _playPause() {
//     try {
//       setState(() {
//         if (_isPlaying) {
//           _audioPlayer.pause();
//         } else {
//           _audioPlayer.play();
//         }
//         _isPlaying = !_isPlaying;
//       });
//     } catch (e) {
//       // Handle error
//     }
//   }

//   void _undo() {
//     final newPosition = _position - Duration(seconds: 10);
//     _audioPlayer.seek(newPosition > Duration.zero ? newPosition : Duration.zero);
//   }

//   void _redo() {
//     final newPosition = _position + Duration(seconds: 10);
//     _audioPlayer.seek(newPosition < _duration ? newPosition : _duration);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.episode['title'])),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             CachedNetworkImage(
//               imageUrl: widget.bookImage,
//               placeholder: (context, url) => const CircularProgressIndicator(),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//               fit: BoxFit.fill,
//             ),
//             Text(widget.title),
//             const SizedBox(height: 10),
//             Text(widget.bookCreatorName),
//             const SizedBox(height: 10),
//             if (_error != null)
//               Text(
//                 _error!,
//                 style: TextStyle(color: Colors.red),
//               )
//             else
//               Column(
//                 children: [
//                   Slider(
//                     value: _currentSliderValue,
//                     min: 0,
//                     max: _duration.inSeconds.toDouble(),
//                     onChanged: (double value) {
//                       setState(() {
//                         _currentSliderValue = value;
//                       });
//                       _audioPlayer.seek(Duration(seconds: value.toInt()));
//                     },
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text(_formatDuration(_position)),
//                       Text(_formatDuration(_duration)),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         DropdownButton<double>(
//                           value: _playbackSpeed,
//                           items: const [
//                             DropdownMenuItem(value: 0.25, child: Text('0.25x')),
//                             DropdownMenuItem(value: 0.5, child: Text('0.5x')),
//                             DropdownMenuItem(value: 0.75, child: Text('0.75x')),
//                             DropdownMenuItem(value: 1.0, child: Text('1.0x')),
//                             DropdownMenuItem(value: 1.25, child: Text('1.25x')),
//                             DropdownMenuItem(value: 1.5, child: Text('1.5x')),
//                             DropdownMenuItem(value: 1.75, child: Text('1.75x')),
//                             DropdownMenuItem(value: 2.0, child: Text('2.0x')),
//                           ],
//                           onChanged: (double? newValue) {
//                             if (newValue != null) {
//                               setState(() {
//                                 _playbackSpeed = newValue;
//                                 _audioPlayer.setSpeed(newValue);
//                               });
//                             }
//                           },
//                           hint: const Text('Playback Speed'),
//                         ),
//                         const SizedBox(width: 10),
//                         IconButton(
//                           onPressed: _playPause,
//                           icon: Icon(
//                             _isPlaying ? Icons.pause : Icons.play_arrow,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: _undo,
//                           icon: const Icon(Icons.replay_10),
//                         ),
//                         IconButton(
//                           onPressed: _redo,
//                           icon: const Icon(Icons.forward_10),
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (!_isDownloaded)
//                     ElevatedButton(
//                       onPressed: _downloadAudio,
//                       child: Text('Download for Offline Playback'),
//                     ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
// }














// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:connectivity_plus/connectivity_plus.dart';

// class AudioPlayerScreen extends StatefulWidget {
//   final dynamic episode;
//   final String title;
//   final String bookCreatorName;
//   final String bookImage;
//   final String audioUrl;
//   const AudioPlayerScreen({
//     super.key,
//     this.episode,
//     required this.title,
//     required this.bookCreatorName,
//     required this.bookImage,
//     required this.audioUrl,
//   });

//   @override
//   _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
// }

// class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
//   late AudioPlayer _audioPlayer;
//   bool _isPlaying = false;
//   double _currentSliderValue = 0;
//   double _playbackSpeed = 1.0;
//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;
//   String? _error;
//   bool _isDownloaded = false;
//   bool _isDownloading = false;
//   bool _isOffline = false;

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     _checkConnectivity();
//     _initializePlayer();
//   }

//   Future<void> _checkConnectivity() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     setState(() {
//       _isOffline = connectivityResult == ConnectivityResult.none;
//     });
//   }

//   Future<void> _initializePlayer() async {
//     if (_isOffline) {
//       setState(() {
//         _error = 'No internet connection. Unable to play audio.';
//       });
//       return;
//     }

//     try {
//       final youtube = YoutubeExplode();
//       final videoId = widget.audioUrl;
//       final manifest = await youtube.videos.streams.getManifest(videoId);
//       final streamInfo = manifest.audioOnly.first;
//       final audioUrl = streamInfo.url.toString();

//       await _audioPlayer.setUrl(audioUrl);
//       _audioPlayer.durationStream.listen((duration) {
//         setState(() {
//           _duration = duration ?? Duration.zero;
//         });
//       });
//       _audioPlayer.positionStream.listen((position) {
//         setState(() {
//           _position = position;
//           _currentSliderValue = _position.inSeconds.toDouble();
//         });
//       });

//       // Start playing automatically
//       _audioPlayer.play();
//       setState(() {
//         _isPlaying = true;
//       });
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to load audio: $e';
//       });
//     }
//   }

//   Future<File> _getLocalFile() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return File('${directory.path}/${widget.episode['id']}.mp3');
//   }

//   Future<void> _downloadAudio() async {
//     setState(() {
//       _isDownloading = true;
//     });
//     try {
//       final youtube = YoutubeExplode();
//       final videoId = widget.audioUrl;
//       final manifest = await youtube.videos.streams.getManifest(videoId);
//       final streamInfo = manifest.audioOnly.first;
//       final audioUrl = streamInfo.url.toString();

//       final response = await http.get(Uri.parse(audioUrl));
//       final file = await _getLocalFile();
//       await file.writeAsBytes(response.bodyBytes);

//       setState(() {
//         _isDownloaded = true;
//         _isDownloading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to download audio: $e';
//         _isDownloading = false;
//       });
//     }
//   }

//   void _playPause() {
//     if (_isOffline) {
//       setState(() {
//         _error = 'No internet connection. Unable to play audio.';
//       });
//       return;
//     }

//     try {
//       setState(() {
//         if (_isPlaying) {
//           _audioPlayer.pause();
//         } else {
//           _audioPlayer.play();
//         }
//         _isPlaying = !_isPlaying;
//       });
//     } catch (e) {
//       setState(() {
//         _error = 'Error playing/pausing audio: $e';
//       });
//     }
//   }

//   void _undo() {
//     if (_isOffline) return;
//     final newPosition = _position - Duration(seconds: 10);
//     _audioPlayer.seek(newPosition > Duration.zero ? newPosition : Duration.zero);
//   }

//   void _redo() {
//     if (_isOffline) return;
//     final newPosition = _position + Duration(seconds: 10);
//     _audioPlayer.seek(newPosition < _duration ? newPosition : _duration);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.episode['title'])),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             CachedNetworkImage(
//               imageUrl: widget.bookImage,
//               placeholder: (context, url) => const CircularProgressIndicator(),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//               fit: BoxFit.fill,
//             ),
//             Text(widget.title),
//             const SizedBox(height: 10),
//             Text(widget.bookCreatorName),
//             const SizedBox(height: 10),
//             if (_error != null)
//               Text(
//                 _error!,
//                 style: TextStyle(color: Colors.red),
//               )
//             else if (_isOffline)
//               Text(
//                 'No internet connection. Audio playback is unavailable.',
//                 style: TextStyle(color: Colors.red),
//               )
//             else
//               Column(
//                 children: [
//                   Slider(
//                     value: _currentSliderValue,
//                     min: 0,
//                     max: _duration.inSeconds.toDouble(),
//                     onChanged: (double value) {
//                       setState(() {
//                         _currentSliderValue = value;
//                       });
//                       _audioPlayer.seek(Duration(seconds: value.toInt()));
//                     },
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text(
//                         _formatDuration(_position),
//                       ),
//                       Text(_formatDuration(_duration)),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         DropdownButton<double>(
//                           value: _playbackSpeed,
//                           items: const [
//                             DropdownMenuItem(value: 0.25, child: Text('0.25x')),
//                             DropdownMenuItem(value: 0.5, child: Text('0.5x')),
//                             DropdownMenuItem(value: 0.6, child: Text('0.6x')),
//                             DropdownMenuItem(value: 0.75, child: Text('0.75x')),
//                             DropdownMenuItem(value: 1.0, child: Text('1.0x')),
//                             DropdownMenuItem(value: 1.25, child: Text('1.25x')),
//                             DropdownMenuItem(value: 1.4, child: Text('1.4x')),
//                             DropdownMenuItem(value: 1.5, child: Text('1.5x')),
//                             DropdownMenuItem(value: 1.75, child: Text('1.75x')),
//                             DropdownMenuItem(value: 2.0, child: Text('2.0x')),
//                             DropdownMenuItem(value: 2.5, child: Text('2.5x')),
//                             DropdownMenuItem(value: 3.0, child: Text('3.0x')),
//                             DropdownMenuItem(value: 3.5, child: Text('3.5x')),
//                             DropdownMenuItem(value: 4.0, child: Text('4.0x')),
//                             DropdownMenuItem(value: 4.5, child: Text('4.5x')),
//                             DropdownMenuItem(value: 5.0, child: Text('5.0x')),
//                             DropdownMenuItem(value: 5.5, child: Text('5.5x')),
//                             DropdownMenuItem(value: 6.0, child: Text('6.0x')),
//                           ],
//                           onChanged: (double? newValue) {
//                             if (newValue != null) {
//                               setState(() {
//                                 _playbackSpeed = newValue;
//                                 _audioPlayer.setSpeed(newValue);
//                               });
//                             }
//                           },
//                           hint: const Text('Playback Speed'),
//                         ),
//                         const SizedBox(width: 10),
//                         IconButton(
//                           onPressed: _playPause,
//                           icon: Icon(
//                             _isPlaying ? Icons.pause : Icons.play_arrow,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: _undo,
//                           icon: const Icon(Icons.replay_10),
//                         ),
//                         IconButton(
//                           onPressed: _redo,
//                           icon: const Icon(Icons.forward_10),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isDownloading || _isDownloaded ? null : _downloadAudio,
//               child: _isDownloading
//                   ? CircularProgressIndicator()
//                   : _isDownloaded
//                       ? Text('Downloaded')
//                       : Text('Download Audio'),
//             ),
//             if (_isDownloaded)
//               Text('Audio downloaded for offline viewing'),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
// }