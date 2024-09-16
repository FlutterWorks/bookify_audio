import 'package:flutter/material.dart';
import 'package:test/page/Home/utils/search_bar_uils.dart';
import '../../../core/feedback.dart';

class AppBarUtil extends StatelessWidget {
  const AppBarUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              feedback(context);
            },
            icon: const Icon(Icons.feedback)),
        const SearchBarUils(),
      ],
    );
  }
}
