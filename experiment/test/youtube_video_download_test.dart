// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController _urlController = TextEditingController();
//   final YoutubeExplode _yt = YoutubeExplode();
//   final Dio _dio = Dio();
//   double _progress = 0.0;
//   bool _isDownloading = false;

//   Future<void> _downloadAudio() async {
//     final url = _urlController.text;
//     if (url.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Please enter a YouTube URL'),
//       ));
//       return;
//     }

//     setState(() {
//       _isDownloading = true;
//       _progress = 0.0;
//     });

//     try {
//       // Request storage permission
//       if (await _requestPermission(Permission.storage)) {
//         // Get video info
//         var video = await _yt.videos.get(url);
//         var manifest = await _yt.videos.streamsClient.getManifest(video.id);
//         var audioStreamInfo = manifest.audioOnly.withHighestBitrate();

//         // Get download directory
//         Directory? appDocDir = await getExternalStorageDirectory();
//         if (appDocDir == null) {
//           throw Exception('Unable to access external storage directory');
//         }
//         String appDocPath = appDocDir.path;
//         String filePath = '$appDocPath/${video.title}.mp3';

//         // Start download
//         await _dio.download(
//           audioStreamInfo.url.toString(),
//           filePath,
//           onReceiveProgress: (received, total) {
//             setState(() {
//               _progress = (received / total);
//             });
//           },
//         );

//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Download completed: ${video.title}.mp3'),
//         ));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Storage permission denied'),
//         ));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error: $e'),
//       ));
//     } finally {
//       setState(() {
//         _isDownloading = false;
//       });
//     }
//   }

//   Future<bool> _requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       var result = await permission.request();
//       return result == PermissionStatus.granted;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('YouTube Audio Downloader'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _urlController,
//               decoration: InputDecoration(
//                 labelText: 'Enter YouTube URL',
//               ),
//             ),
//             SizedBox(height: 20),
//             _isDownloading
//                 ? Column(
//                     children: [
//                       LinearProgressIndicator(value: _progress),
//                       SizedBox(height: 20),
//                       Text(
//                         '${(_progress * 100).toStringAsFixed(2)}%',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                     ],
//                   )
//                 : ElevatedButton(
//                     onPressed: _downloadAudio,
//                     child: Text('Download Audio'),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _yt.close();
//     _urlController.dispose();
//     super.dispose();
//   }
// }
