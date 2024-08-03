import 'package:flutter/material.dart';
import 'package:test/page/Home/widget/home_page_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth =
        (screenWidth - 40) / 3; // Subtracting padding and spacing
    final double imageHeight =
        imageWidth * 1.5; // Maintaining a 2:3 aspect ratio

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: HomePageListWidget(
            imageHeight: imageHeight,
            imageWidth: imageWidth,
            homepageListTile: 'Free',
            homepageListImage: 'image',
            dataSaveName: 'FreeSave',
            apiurl: 'https://apon10510.github.io/bookify_api/dummy_api.json',
          ),
        ),
      ),
    );
  }
}
