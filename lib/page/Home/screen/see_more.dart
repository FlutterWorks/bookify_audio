// import 'package:app_gokai/feature/full_screen/widgets/grid_card.dart';
import 'package:flutter/material.dart';
import 'package:test/page/Home/widget/see_more_list_widget.dart';

class SeeMorePage extends StatelessWidget {
  final String seemorepageListTile;
  final Function()? clickEpisode;
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
    this.clickEpisode,
    required this.seeMorePageListImage,
    required this.imageHeight,
    required this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    // final double screenWidth = MediaQuery.of(context).size.width;
    // final double imageWidth =
    //     (screenWidth - 40) / 3; // Subtracting padding and spacing
    // final double imageHeight =
    //     imageWidth * 1.5; // Maintaining a 2:3 aspect ratio
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
