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


    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: HomePageListWidget(
              // imageHeight: imageHeight,
              // imageWidth: imageWidth,
              // homepageListTile: 'Free',
              // homepageListImage: 'image',
              // dataSaveName: 'FreeSave',
              // apiurl: 'https://apon10510.github.io/bookify_api/dummy_api.json',
              // seeMorePageListTitle: 'title',
              // seeMorePageListCreatorName: 'bookCreatorName',
              ),
        ),
      ),
    );
  }
}
