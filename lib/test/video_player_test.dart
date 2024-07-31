import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const VideoApp());

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://www.example.com/video.mp4')) // Replace with your video URL
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Video Player'),
        ),
        body: Center(
          child: _controller.value.isInitialized
              ? Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.replay_10, color: Colors.white),
                            onPressed: () {
                              final currentPosition = _controller.value.position;
                              _controller.seekTo(currentPosition - const Duration(seconds: 10));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.forward_10, color: Colors.white),
                            onPressed: () {
                              final currentPosition = _controller.value.position;
                              _controller.seekTo(currentPosition + const Duration(seconds: 10));
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying ? Icons.fullscreen_exit : Icons.fullscreen,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (_controller.value.isPlaying) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenVideo(controller: _controller),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 0,
                      right: 0,
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: Colors.red,
                          bufferedColor: Colors.grey,
                          backgroundColor: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FullScreenVideo extends StatelessWidget {
  final VideoPlayerController controller;

  const FullScreenVideo({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// void main() => runApp(const VideoApp());

// class VideoApp extends StatefulWidget {
//   const VideoApp({super.key});

//   @override
//   _VideoAppState createState() => _VideoAppState();
// }

// class _VideoAppState extends State<VideoApp> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(
//         'https://rr5---sn-ax8xaj5ggpxg-q5j6.googlevideo.com/videoplayback?expire=1722447852&ei=jCOqZrLXIP2y2roPwavlmAE&ip=103.209.173.10&id=o-AJadE8U8WXPVQOvbzYv1hFcv1EkWy1gUASpxjx4FtZz4&itag=18&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&mh=zm&mm=31%2C29&mn=sn-ax8xaj5ggpxg-q5j6%2Csn-npoldn7l&ms=au%2Crdu&mv=m&mvi=5&pl=24&initcwndbps=1108750&vprv=1&svpuc=1&mime=video%2Fmp4&rqh=1&cnr=14&ratebypass=yes&dur=245.667&lmt=1722076992340204&mt=1722425862&fvip=5&c=ANDROID_TESTSUITE&txp=5538434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cvprv%2Csvpuc%2Cmime%2Crqh%2Ccnr%2Cratebypass%2Cdur%2Clmt&sig=AJfQdSswRQIgVt4RzNJh4Sp8DdJUt-n8CMxRcwoo9_cyxd95K78fnJACIQDtZVra4DsOfBn1Vr4ZiQxxbLSWFYx6reNmLDL3OS6tzg%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AGtxev0wRgIhAIPezt15T6_wG4oME2cr2wK3NtaoieVHKWDLjXY7jCnvAiEA0NV9H_qmDia2TCFrKF3_yk7hGRPBvTNNlskkXg6cIrc%3D')) // Replace with your video URL
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Video Player'),
//         ),
//         body: Center(
//           child: _controller.value.isInitialized
//               ? Stack(
//                   alignment: Alignment.bottomCenter,
//                   children: [
//                     AspectRatio(
//                       aspectRatio: _controller.value.aspectRatio,
//                       child: VideoPlayer(_controller),
//                     ),
//                     _ControlsOverlay(controller: _controller),
//                     VideoProgressIndicator(_controller, allowScrubbing: true),
//                   ],
//                 )
//               : const CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// class _ControlsOverlay extends StatefulWidget {
//   const _ControlsOverlay({required this.controller});

//   final VideoPlayerController controller;

//   @override
//   __ControlsOverlayState createState() => __ControlsOverlayState();
// }

// class __ControlsOverlayState extends State<_ControlsOverlay> {
//   static const List<double> _playbackRates = [0.5, 1.0, 1.5, 2.0];
//   bool _isPlaying = false;
//   bool _isFullScreen = false;

//   @override
//   void initState() {
//     super.initState();
//     _isPlaying = widget.controller.value.isPlaying;
//     widget.controller.addListener(() {
//       setState(() {
//         _isPlaying = widget.controller.value.isPlaying;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: const Duration(milliseconds: 50),
//           reverseDuration: const Duration(milliseconds: 200),
//           child: !_isPlaying
//               ? Container(
//                   color: Colors.black26,
//                   child: const Center(
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 100.0,
//                       semanticLabel: 'Play',
//                     ),
//                   ),
//                 )
//               : const SizedBox.shrink(),
//         ),
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               if (_isPlaying) {
//                 widget.controller.pause();
//               } else {
//                 widget.controller.play();
//               }
//               _isPlaying = !_isPlaying;
//             });
//           },
//         ),
//         Align(
//           alignment: Alignment.topLeft,
//           child: PopupMenuButton<double>(
//             initialValue: widget.controller.value.playbackSpeed,
//             tooltip: 'Playback speed',
//             onSelected: (speed) {
//               widget.controller.setPlaybackSpeed(speed);
//             },
//             itemBuilder: (context) {
//               return [
//                 for (final speed in _playbackRates)
//                   PopupMenuItem(
//                     value: speed,
//                     child: Text('${speed}x'),
//                   )
//               ];
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 12,
//                 horizontal: 16,
//               ),
//               child: Text('${widget.controller.value.playbackSpeed}x'),
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerLeft,
//           child: IconButton(
//             icon: const Icon(Icons.replay_10, color: Colors.white),
//             onPressed: () {
//               final currentPosition = widget.controller.value.position;
//               widget.controller.seekTo(currentPosition - const Duration(seconds: 10));
//             },
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: IconButton(
//             icon: const Icon(Icons.forward_10, color: Colors.white),
//             onPressed: () {
//               final currentPosition = widget.controller.value.position;
//               widget.controller.seekTo(currentPosition + const Duration(seconds: 10));
//             },
//           ),
//         ),
//         Align(
//           alignment: Alignment.topRight,
//           child: IconButton(
//             icon: Icon(
//               _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               if (_isFullScreen) {
//                 Navigator.of(context).pop();
//               } else {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => FullScreenVideo(controller: widget.controller),
//                   ),
//                 );
//               }
//               setState(() {
//                 _isFullScreen = !_isFullScreen;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class FullScreenVideo extends StatelessWidget {
//   final VideoPlayerController controller;

//   const FullScreenVideo({Key? key, required this.controller}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: VideoPlayer(controller),
//         ),
//       ),
//       backgroundColor: Colors.black,
//     );
//   }
// }
