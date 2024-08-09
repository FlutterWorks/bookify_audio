// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:search_page/search_page.dart';

// class IconSearchBarUtil extends StatefulWidget {
//   const IconSearchBarUtil({super.key});

//   @override
//   State<IconSearchBarUtil> createState() => SsearchBarStateUtil();
// }

// class SsearchBarStateUtil extends State<IconSearchBarUtil> {
//   dynamic data;
//   Future getData() async {
//     var res = await http.get(Uri.parse(
//         'https://castor-parachutes.000webhostapp.com/apiforlink.php?token=1z14ecxgs1tbt9cb54sa'));
//     try {
//       setState(() {
//         var decode = json.decode(res.body).cast<Map<String, dynamic>>();
//         data = decode;
//       });
//     } catch (e) {
//       //
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         showSearch(
//           context: context,
//           delegate: SearchPage<Map<String, dynamic>>(
//             failure: const Center(
//               child: Text('No App found :('),
//             ),
//             searchLabel: 'Search App',
//             builder: (builder) {
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     ListTile(
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (b) => WebViewPage(
//                               url: builder['allurl'].toString(),
//                             ),
//                           ),
//                         );
//                       },
//                       title: Text(builder['allappname'].toString()),
//                       leading: SizedBox(
//                         height: 40,
//                         width: 40,
//                         child: CachedNetworkImage(
//                           imageUrl: builder['allappimage'].toString(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             filter: (filter) => [
//               filter['allappname'].toString(),
//             ],
//             items: data,
//           ),
//         );
//       },
//       icon: const Icon(Icons.search),
//     );
//   }
// }
