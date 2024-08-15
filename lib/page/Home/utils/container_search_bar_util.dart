// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:search_page/search_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:test/page/Home/screen/episode_page.dart';

// class ContainerSearchBarUtils extends StatefulWidget {
//   const ContainerSearchBarUtils({super.key});

//   @override
//   State<ContainerSearchBarUtils> createState() =>
//       _ContainerSearchBarUtilsState();
// }

// class _ContainerSearchBarUtilsState extends State<ContainerSearchBarUtils> {
//   List<Map<String, dynamic>> data = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   Future<void> getData() async {
//     try {
//       final res = await http.get(
//         Uri.parse('https://apon06.github.io/bookify_api/dummy_api.json'),
//       );
//       if (res.statusCode == 200) {
//         final decoded = json.decode(res.body);
//         setState(() {
//           data = List<Map<String, dynamic>>.from(decoded['audiobooks']);
//           isLoading = false;
//         });
//         await saveDataToPreferences();
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       // print('Error fetching data: $e');
//       setState(() {
//         isLoading = false;
//       });
//       // Optionally show an error message to the user
//     }
//   }

//   Future<void> saveDataToPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('save', json.encode(data));
//   }

//   Future<void> loadData() async {
//     setState(() {
//       isLoading = true;
//     });

//     final prefs = await SharedPreferences.getInstance();
//     final savedData = prefs.getString('save');

//     if (savedData != null) {
//       setState(() {
//         data = List<Map<String, dynamic>>.from(json.decode(savedData));
//         isLoading = false;
//       });
//     }
//     await getData();
//   }

//   Future<void> refreshData() async {
//     setState(() {
//       isLoading = true;
//     });
//     await getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (data.isEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text(
//                     'No data available. Please check your internet connection and try again.')),
//           );
//           return;
//         }
//         showSearch(
//           context: context,
//           delegate: SearchPage<Map<String, dynamic>>(
//             failure: const Center(
//               child: Text('No App found :('),
//             ),
//             searchLabel: 'Search App',
//             builder: (builder) {
//               dynamic book = builder;
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (b) => EpisodeListPage(
//                           audiobook: book,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     elevation: 5,
//                     child: SizedBox(
//                       height: 135,
//                       width: MediaQuery.of(context).size.width * .99,
//                       child: Padding(
//                         padding: const EdgeInsets.all(3),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: SizedBox(
//                                     height: 120,
//                                     width: 100,
//                                     child: CachedNetworkImage(
//                                       imageUrl: builder['image'].toString(),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                           "নাম: ${builder['title'].toString()}"),
//                                       Text(
//                                           'লেখক: ${builder['bookCreatorName'].toString()}'),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//             filter: (filter) => [
//               filter['title'].toString(),
//             ],
//             items: data,
//           ),
//         );
//       },
//       child: Container(
//         height: 40,
//         width: 300,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Text(
//                 isLoading ? 'Loading...' : 'Search Here',
//                 style: const TextStyle(fontSize: 15, color: Colors.grey),
//               ),
//             ),
//             if (isLoading)
//               const Padding(
//                 padding: EdgeInsets.only(right: 10),
//                 child: SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/page/Home/screen/episode_page.dart';

class ContainerSearchBarUtils extends StatefulWidget {
  const ContainerSearchBarUtils({super.key});

  @override
  State<ContainerSearchBarUtils> createState() =>
      _ContainerSearchBarUtilsState();
}

class _ContainerSearchBarUtilsState extends State<ContainerSearchBarUtils> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> getData() async {
    try {
      final res = await http.get(
        Uri.parse('https://apon06.github.io/bookify_api/dummy_api.json'),
      );
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        setState(() {
          data = List<Map<String, dynamic>>.from(decoded['audiobooks']);
          isLoading = false;
        });
        await saveDataToPreferences();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
      // Optionally show an error message to the user
    }
  }

  Future<void> saveDataToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('save', json.encode(data));
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('save');

    if (savedData != null) {
      setState(() {
        data = List<Map<String, dynamic>>.from(json.decode(savedData));
        isLoading = false;
      });
    }
    await getData();
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (data.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'No data available. Please check your internet connection and try again.')),
          );
          return;
        }
        showSearch(
          context: context,
          delegate: SearchPage<Map<String, dynamic>>(
            failure: const Center(
              child: Text('No App found :('),
            ),
            searchLabel: 'Search App',
            builder: (builder) {
              dynamic book = builder;
              return Padding(
                padding: const EdgeInsets.all(8.0),
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
                  child: Card(
                    elevation: 5,
                    child: SizedBox(
                      height: 135,
                      width: MediaQuery.of(context).size.width * .99,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    height: 120,
                                    width: 100,
                                    child: CachedNetworkImage(
                                      imageUrl: builder['bookImage'].toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "নাম: ${builder['bookName'].toString()}"),
                                      Text(
                                          'লেখক: ${builder['bookCreatorName'].toString()}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            filter: (filter) => [
              filter['bookName'].toString(),
              filter['bookNameEn'].toString(),
            ],
            items: data,
          ),
        );
      },
      child: const Padding(
        padding: EdgeInsets.only(right: 5),
        child: SizedBox(
          // height: 40,
          width: 50,
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(10),
          // ),
          child: Icon(Icons.search),
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(left: 10),
          //       child: Text(
          //         isLoading ? 'Loading...' : 'Search Here',
          //         style: const TextStyle(fontSize: 15, color: Colors.grey),
          //       ),
          //     ),
          //     if (isLoading)
          //       const Padding(
          //         padding: EdgeInsets.only(right: 10),
          //         child: SizedBox(
          //           width: 20,
          //           height: 20,
          //           child: CircularProgressIndicator(
          //             strokeWidth: 2,
          //           ),
          //         ),
          //       ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
