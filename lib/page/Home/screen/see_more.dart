import 'package:flutter/material.dart';
import 'package:test/page/Home/widget/see_more_list_widget.dart';

class SeeMorePage extends StatelessWidget {
  final String api;
  final String bookType;
  final String bookImage;

  final String bookName;
  final String bookCreatorName;
  const SeeMorePage({
    super.key,
    required this.api,
    required this.bookType,
    required this.bookImage,
    required this.bookName,
    required this.bookCreatorName,
  });

  @override
  Widget build(BuildContext context) {
    return SeeMoreListWidget(
      api: api,
      bookType: bookType,
      bookImage: bookImage,
      bookName: bookName,
      bookCreatorName: bookCreatorName,
    );
  }
}
