import 'package:flutter/material.dart';
import 'package:test/page/Home/screen/writer_details_page_see_more.dart';

class WriterDetailsPage extends StatelessWidget {
  final String api;
  final String bookImage;
  final String saveKey;
  final String bookName;
  final String bookCreatorName;
  final String writerImage;
  const WriterDetailsPage({
    super.key,
    required this.api,
    required this.bookImage,
    required this.bookName,
    required this.bookCreatorName,
    required this.saveKey,
    required this.writerImage,
  });

  @override
  Widget build(BuildContext context) {
    return WriterDetailsPageSeeMore(
      api: api,
      bookImage: bookImage,
      bookName: bookName,
      bookCreatorName: bookCreatorName,
      saveKey: saveKey,
      writerImage: writerImage,
    );
  }
}
