// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:test/page/Home/screen/writer_details_page.dart';
// import 'package:test/page/Home/widget/category_button_widget.dart';

// class WriterUtils extends StatefulWidget {
//   const WriterUtils({super.key});

//   @override
//   State<WriterUtils> createState() => _WriterUtilsState();
// }

// class _WriterUtilsState extends State<WriterUtils> {
//   List<dynamic> categoryList = [];
//   bool isLoading = true;
//   dynamic selectedPerson;

//   Future<void> getData() async {
//     final res = await http.get(
//       Uri.parse('https://apon06.github.io/bookify_api/category.json'),
//     );
//     if (res.statusCode == 200) {
//       final decoded = json.decode(res.body);
//       if (mounted) {
//         setState(() {
//           categoryList = decoded['Category'];
//           isLoading = false;
//           selectedPerson = categoryList.isNotEmpty ? categoryList[0] : null;
//         });
//         await saveDataToPreferences();
//       }
//     } else {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> saveDataToPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('CategorySaveKey', json.encode(categoryList));
//   }

//   Future<void> loadData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedData = prefs.getString('CategorySaveKey');
//     if (savedData != null) {
//       if (mounted) {
//         setState(() {
//           categoryList = json.decode(savedData);
//           selectedPerson = categoryList.isNotEmpty ? categoryList[0] : null;
//           isLoading = false;
//         });
//       }
//     }
//     await getData();
//   }

//   Future<void> refreshData() async {
//     if (mounted) {
//       setState(() {
//         isLoading = true;
//       });
//     }
//     await getData();
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 32,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: categoryList.length,
//         itemBuilder: (b, index) {
//           var categoryApi = categoryList[index];
//           return CategoryButtonWidget(
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => WriterDetailsPage(
//                   api: categoryApi["api"],
//                   bookType: categoryApi["bookType"],
//                   bookImage: categoryApi["bookImage"],
//                   bookName: categoryApi["bookName"],
//                   bookCreatorName: categoryApi["bookCreatorName"],
//                   saveKey: 'categorySave',
//                 ),
//               ),
//             ),
//             categoryText: categoryApi["bookType"],
//             categoryColor: categoryApi["color"],
//           );
//         },
//       ),
//     );
//   }
// }






