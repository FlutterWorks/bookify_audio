// import 'package:flutter/material.dart';
// import 'extract_audio.dart';

// class YouTubeUrlInput extends StatelessWidget {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enter YouTube URL'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: 'YouTube URL',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 String url = _controller.text;
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ExtractAudio(youtubeUrl: url),
//                   ),
//                 );
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
