// import 'package:app_gokai/core/advance/feedback.dart';
import 'package:flutter/material.dart';
import 'package:test/page/Home/utils/container_search_bar_util.dart';

class AppBarUtil extends StatelessWidget {
  const AppBarUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ContainerSearchBarUtils(),
        // IconButton(
        //   onPressed: () {
        //     feedback(context);
        //   },
        //   icon: const Icon(Icons.feedback),
        // ),
      ],
    );
  }
}

// 27768810