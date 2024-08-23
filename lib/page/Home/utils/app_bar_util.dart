import 'package:flutter/material.dart';
import 'package:test/page/Home/utils/container_search_bar_util.dart';

class AppBarUtil extends StatelessWidget {
  const AppBarUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ContainerSearchBarUtils(),
      ],
    );
  }
}
