import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/page/Home/screen/see_more.dart';
import 'package:test/page/Home/widget/category_button_widget.dart';

class CategoryListUtils extends StatefulWidget {
  const CategoryListUtils({super.key});

  @override
  State<CategoryListUtils> createState() => _CategoryListUtilsState();
}

class _CategoryListUtilsState extends State<CategoryListUtils> {
  List<dynamic> categoryList = [];
  bool isLoading = true;
  dynamic selectedPerson;

  Future<void> getData() async {
    final res = await http.get(
      Uri.parse('https://apon06.github.io/bookify_api/category.json'),
    );
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      setState(() {
        categoryList = decoded['Category'];
        isLoading = false;
        selectedPerson = categoryList.isNotEmpty ? categoryList[0] : null;
      });
      await saveDataToPreferences();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveDataToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('CategorySaveKey', json.encode(categoryList));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('CategorySaveKey');
    if (savedData != null) {
      setState(() {
        categoryList = json.decode(savedData);
        selectedPerson = categoryList.isNotEmpty ? categoryList[0] : null;
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
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        itemBuilder: (b, index) {
          var categoryApi = categoryList[index];
          return CategoryButtonWidget(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SeeMorePage(
                  api: categoryApi["api"],
                  bookType: categoryApi["bookName"],
                  bookImage: categoryApi["bookImage"],
                  bookName: categoryApi["bookName"],
                  bookCreatorName: categoryApi["bookCreatorName"],
                ),
              ),
            ),
            categoryText: categoryApi["bookType"],
            categoryColor: categoryApi["color"],
          );
        },
      ),
    );
  }
}
