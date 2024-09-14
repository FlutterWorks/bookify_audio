import 'package:flutter/material.dart';
import 'package:test/page/Home/utils/search_bar_uils.dart';

class AppBarUtil extends StatelessWidget {
  const AppBarUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SearchBarUils(),
      ],
    );
  }
}
