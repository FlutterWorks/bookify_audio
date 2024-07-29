// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

// class PlayAudio extends StatefulWidget {
//   final String audioUrl;

//   PlayAudio({required this.audioUrl});

//   @override
//   _PlayAudioState createState() => _PlayAudioState();
// }

// class _PlayAudioState extends State<PlayAudio> {
//   late AudioPlayer _audioPlayer;

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   Future<void> _playAudio() async {
//     final player = _audioPlayer;
//     await player.play(UrlSource(widget.audioUrl));
//   }

//   Future<void> _pauseAudio() async {
//     await _audioPlayer.pause();
//   }

//   Future<void> _resumeAudio() async {
//     await _audioPlayer.resume();
//   }

//   Future<void> _stopAudio() async {
//     await _audioPlayer.stop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Playing Audio'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: _playAudio,
//               child: Text('Play Audio'),
//             ),
//             ElevatedButton(
//               onPressed: _pauseAudio,
//               child: Text('Pause Audio'),
//             ),
//             ElevatedButton(
//               onPressed: _resumeAudio,
//               child: Text('Resume Audio'),
//             ),
//             ElevatedButton(
//               onPressed: _stopAudio,
//               child: Text('Stop Audio'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







// // import 'package:flutter/material.dart';
// // import 'package:just_audio/just_audio.dart';

// // class PlayAudio extends StatelessWidget {
// //   final String audioUrl;

// //   const PlayAudio({super.key, required this.audioUrl});

// //   @override
// //   Widget build(BuildContext context) {
// //     // Create an instance of AudioPlayer
// //     final AudioPlayer _audioPlayer = AudioPlayer();

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Playing Audio'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             ElevatedButton(
// //               onPressed: () async {
// //                 // Set the audio source and play
// //                 await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
// //                 _audioPlayer.play();
// //               },
// //               child: const Text('Play Audio'),
// //             ),
// //             ElevatedButton(
// //               onPressed: () async {
// //                 _audioPlayer.pause();
// //               },
// //               child: const Text('Pause Audio'),
// //             ),
// //             ElevatedButton(
// //               onPressed: () async {
// //                 _audioPlayer.stop();
// //               },
// //               child: const Text('Stop Audio'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
