// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(const PlantIdentifierApp());
// }

// class PlantIdentifierApp extends StatelessWidget {
//   const PlantIdentifierApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Plant Identifier',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const PlantIdentifierPage(),
//     );
//   }
// }

// class PlantIdentifierPage extends StatefulWidget {
//   const PlantIdentifierPage({super.key});

//   @override
//   _PlantIdentifierPageState createState() => _PlantIdentifierPageState();
// }

// class _PlantIdentifierPageState extends State<PlantIdentifierPage> {
//   File? _image;
//   String _result = '';
//   bool _isLoading = false;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _getImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         _result = '';
//       }
//     });
//   }

//   Future<void> _identifyPlant() async {
//     if (_image == null) return;

//     setState(() {
//       _isLoading = true;
//     });

//     const apiKey = 'Your Api Key'; // Your API key
//     const apiUrl =
//         'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

//     try {
//       final bytes = await _image!.readAsBytes();
//       final base64Image = base64Encode(bytes);

//       final response = await http.post(
//         Uri.parse('$apiUrl?key=$apiKey'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'contents': [
//             {
//               'parts': [
//                 {
//                   'text':
//                       'Identify this plant and provide some information about it.'
//                 },
//                 {
//                   'inline_data': {
//                     'mime_type': 'image/jpeg',
//                     'data': base64Image,
//                   }
//                 }
//               ]
//             }
//           ]
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _result = data['candidates'][0]['content']['parts'][0]['text'];
//         });
//       } else {
//         setState(() {
//           _result = 'Error ${response.statusCode}: ${response.body}';
//           // print('API Response: ${response.body}'); // Log the response for debugging
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _result = 'Error: $e';
//         // print('Exception: $e'); // Log exception for debugging
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Plant Identifier'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               _image == null
//                   ? Container(
//                       height: 300,
//                       color: Colors.grey[200],
//                       child:
//                           Icon(Icons.image, size: 100, color: Colors.grey[400]),
//                     )
//                   : Image.file(_image!, height: 300, fit: BoxFit.cover),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => _getImage(ImageSource.camera),
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text('Camera'),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => _getImage(ImageSource.gallery),
//                     icon: const Icon(Icons.photo_library),
//                     label: const Text('Gallery'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _image == null ? null : _identifyPlant,
//                 child: const Text('Identify Plant'),
//               ),
//               const SizedBox(height: 16),
//               _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : Text(
//                       _result,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
