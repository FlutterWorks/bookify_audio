import 'package:flutter/material.dart';
import 'package:test/page/Home/widget/see_more_list_widget.dart';

class SeeMorePage extends StatelessWidget {
  final String seemorepageListTile;
  final String seeMorePageListImage;
  final String dataSaveName;
  final String apiurl;
  final double imageHeight;
  final double imageWidth;
  const SeeMorePage({
    super.key,
    required this.apiurl,
    required this.dataSaveName,
    required this.seemorepageListTile,
    required this.seeMorePageListImage,
    required this.imageHeight,
    required this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(seemorepageListTile),
      ),
      body: SafeArea(
        child: SeeMoreGridWidget(
          apiurl: apiurl,
          dataSaveName: dataSaveName,
          seemorepageListTile: seemorepageListTile,
          seeMorePageListImage: seeMorePageListImage,
          imageHeight: imageHeight,
          imageWidth: imageHeight,
        ),
      ),
    );
  }
}
