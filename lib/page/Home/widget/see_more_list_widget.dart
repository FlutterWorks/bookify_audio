// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:test/page/Home/screen/episode_page.dart';

// class SeeMoreListWidget extends StatefulWidget {
//   final String seeMorePageListImage;
//   final String seeMorePageListTitle;
//   final String seeMorePageListCreatorName;
//   final String dataSaveName;
//   final String apiurl;
//   final double imageHeight;
//   final double imageWidth;
//   const SeeMoreListWidget({
//     super.key,
//     required this.apiurl,
//     required this.dataSaveName,
//     required this.seeMorePageListImage,
//     required this.imageHeight,
//     required this.imageWidth,
//     required this.seeMorePageListTitle,
//     required this.seeMorePageListCreatorName,
//   });

//   @override
//   State<SeeMoreListWidget> createState() => _SeeMoreListWidgetState();
// }

// class _SeeMoreListWidgetState extends State<SeeMoreListWidget> {
//   List<dynamic>? _audiobooks;
//   bool _isLoading = true;
//   String? _error;

//   Future<void> fetchAudiobooks() async {
//     final prefs = await SharedPreferences.getInstance();
//     final storedData = prefs.getString(widget.dataSaveName);

//     if (storedData != null) {
//       setState(() {
//         _audiobooks = jsonDecode(storedData)['audiobooks'];
//         _isLoading = false;
//       });
//     } else {
//       try {
//         final response = await http.get(Uri.parse(widget.apiurl));
//         if (response.statusCode == 200) {
//           final json = jsonDecode(response.body);
//           prefs.setString(widget.dataSaveName, response.body);
//           setState(() {
//             _audiobooks = json['audiobooks'];
//             _isLoading = false;
//           });
//         } else {
//           throw Exception('Failed to load audiobooks');
//         }
//       } catch (error) {
//         setState(() {
//           _error = error.toString();
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchAudiobooks();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : _error != null
//             ? Center(child: Text('Error: $_error'))
//             : ListView.builder(
//                 itemCount: _audiobooks!.length,
//                 itemBuilder: (context, index) {
//                   var book = _audiobooks![index];
//                   return Padding(
//                     padding: const EdgeInsets.all(5),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (b) => EpisodeListPage(
//                               audiobook: book,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         height: 135,
//                         width: MediaQuery.of(context).size.width * .99,
//                         decoration: BoxDecoration(
//                             border: Border.all(),
//                             borderRadius: BorderRadius.circular(4)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(3),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     height: 120,
//                                     width: 100,
//                                     child: CachedNetworkImage(
//                                       imageUrl:
//                                           book[widget.seeMorePageListImage],
//                                           fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(book[widget.seeMorePageListTitle]),
//                                         Text(book[
//                                             widget.seeMorePageListCreatorName]),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//   }
// }







import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/page/Home/screen/episode_page.dart';

class SeeMoreListWidget extends StatefulWidget {
  final String seeMorePageListImage;
  final String seeMorePageListTitle;
  final String seeMorePageListCreatorName;
  final String dataSaveName;
  final String apiurl;
  final double imageHeight;
  final double imageWidth;

  const SeeMoreListWidget({
    super.key,
    required this.apiurl,
    required this.dataSaveName,
    required this.seeMorePageListImage,
    required this.imageHeight,
    required this.imageWidth,
    required this.seeMorePageListTitle,
    required this.seeMorePageListCreatorName,
  });

  @override
  State<SeeMoreListWidget> createState() => _SeeMoreListWidgetState();
}

class _SeeMoreListWidgetState extends State<SeeMoreListWidget> {
  final StreamController<List<dynamic>> _streamController = StreamController();
  bool _isLoading = true;
  String? _error;

  Future<void> fetchAudiobooks() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString(widget.dataSaveName);

    if (storedData != null) {
      final audiobooks = jsonDecode(storedData)['audiobooks'];
      _streamController.add(audiobooks);
      setState(() {
        _isLoading = false;
      });
    } else {
      try {
        final response = await http.get(Uri.parse(widget.apiurl));
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          prefs.setString(widget.dataSaveName, response.body);
          _streamController.add(json['audiobooks']);
          setState(() {
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to load audiobooks');
        }
      } catch (error) {
        setState(() {
          _error = error.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAudiobooks();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? Center(child: Text('Error: $_error'))
            : StreamBuilder<List<dynamic>>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    var audiobooks = snapshot.data!;
                    return ListView.builder(
                      itemCount: audiobooks.length,
                      itemBuilder: (context, index) {
                        var book = audiobooks[index];
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
                            child: Container(
                              height: 135,
                              width: MediaQuery.of(context).size.width * .99,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 120,
                                          width: 100,
                                          child: CachedNetworkImage(
                                            imageUrl: book[
                                                widget.seeMorePageListImage],
                                            fit: BoxFit.cover,
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
                                              Text(book[
                                                  widget.seeMorePageListTitle]),
                                              Text(book[widget
                                                  .seeMorePageListCreatorName]),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              );
  }
}
