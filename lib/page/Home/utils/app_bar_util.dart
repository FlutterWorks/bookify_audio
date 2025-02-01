import 'package:flutter/material.dart';

import 'search_bar_uils.dart';

class AppBarUtil extends StatelessWidget {
  const AppBarUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        // IconButton(
        //     onPressed: () {
        //       feedback(context);
        //     },
        //     icon: const Icon(Icons.feedback)),
         SearchBarUils(),
      ],
    );
  }
}
