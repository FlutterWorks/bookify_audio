import 'package:flutter/material.dart';
import 'package:test/page/Home/utils/slider_image_utils.dart';
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
          child: Column(
            children: [
              SizedBox(height: 10),
              ImageSliderScreen(),
              HomePageListWidget(
                api:
                    'https://castor-parachutes.000webhostapp.com/apiforlink.php?token=1z14ecxgs1tbt9cb54sa',
                bookType: 'রবীন্দ্রনাথ ঠাকুর',
                bookImage: 'image',
                saveKey: 'save_bangladesh',
                bookCreatorName: 'bookCreatorName',
                bookName: 'title',
              ),
              HomePageListWidget(
                api:
                    'https://castor-parachutes.000webhostapp.com/apiforlink.php?token=1z14ecxgs1tbt9cb54sa',
                bookType: 'রবীন্দ্রনাথ ঠাকুর',
                bookImage: 'image',
                saveKey: 'save_bangladesh',
                bookCreatorName: 'bookCreatorName',
                bookName: 'title',
              ),
              HomePageListWidget(
                api:
                    'https://castor-parachutes.000webhostapp.com/apiforlink.php?token=1z14ecxgs1tbt9cb54sa',
                bookType: 'রবীন্দ্রনাথ ঠাকুর',
                bookImage: 'image',
                saveKey: 'save_bangladesh',
                bookCreatorName: 'bookCreatorName',
                bookName: 'title',
              ),
              HomePageListWidget(
                api:
                    'https://castor-parachutes.000webhostapp.com/apiforlink.php?token=1z14ecxgs1tbt9cb54sa',
                bookType: 'রবীন্দ্রনাথ ঠাকুর',
                bookImage: 'image',
                saveKey: 'save_bangladesh',
                bookCreatorName: 'bookCreatorName',
                bookName: 'title',
              ),
              HomePageListWidget(
                api:
                    'https://castor-parachutes.000webhostapp.com/apiforlink.php?token=1z14ecxgs1tbt9cb54sa',
                bookType: 'রবীন্দ্রনাথ ঠাকুর',
                bookImage: 'image',
                saveKey: 'save_bangladesh',
                bookCreatorName: 'bookCreatorName',
                bookName: 'title',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
