import 'package:flutter/material.dart';
import 'package:test/page/Home/widget/see_more_list_widget.dart';

class SeeMorePage extends StatelessWidget {
  final String seemorepageListTile;
  final String seeMorePageListImage;
  final String dataSaveName;
  final String apiurl;
  final double imageHeight;
  final double imageWidth;
    final String seeMorePageListTitle ;
  final String seeMorePageListCreatorName ;
  const SeeMorePage({
    super.key,
    required this.apiurl,
    required this.dataSaveName,
    required this.seemorepageListTile,
    required this.seeMorePageListImage,
    required this.imageHeight,
    required this.imageWidth, required this.seeMorePageListTitle, required this.seeMorePageListCreatorName,
    
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(seemorepageListTile),
      ),
      body: SafeArea(
        child: SeeMoreListWidget(
          apiurl: apiurl,
          dataSaveName: dataSaveName,
          seeMorePageListImage: seeMorePageListImage,
          imageHeight: imageHeight,
          imageWidth: imageHeight, seeMorePageListTitle: seeMorePageListTitle, seeMorePageListCreatorName: seeMorePageListCreatorName,
        ),
      ),
    );
  }
}
