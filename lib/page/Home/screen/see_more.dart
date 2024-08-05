import 'package:flutter/material.dart';
import 'package:test/page/Home/widget/see_more_list_widget.dart';

class SeeMorePage extends StatelessWidget {
  const SeeMorePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SeeMoreListWidget(
      api: 'https://apon10510.github.io/bookify_api/dummy_api.json',
      bookType: 'Free Bangladesh',
      bookImage: 'image',
      saveKey: 'save_bangladesh',
      bookName: 'title',
      bookCreator: 'bookCreatorName',
    );
  }
}
