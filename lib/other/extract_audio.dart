// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'play_audio.dart';

// class ExtractAudio extends StatelessWidget {
//   final String youtubeUrl;

//   ExtractAudio({required this.youtubeUrl});

//   Future<String> extractAudio() async {
//     final response = await http.post(
//       Uri.parse('E:/Extansion/exprement/youtube/lib/backend/extract_audio'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'url': youtubeUrl,
//       }),
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body)['audio_file'];
//     } else {
//       throw Exception('Failed to extract audio');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Extracting Audio'),
//       ),
//       body: FutureBuilder<String>(
//         future: extractAudio(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PlayAudio(audioUrl: snapshot.data!),
//                     ),
//                   );
//                 },
//                 child: Text('Play Audio'),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
