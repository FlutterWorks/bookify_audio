import 'package:flutter/material.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

void main() => runApp(const AdExampleApp());

class AdExampleApp extends StatelessWidget {
  const AdExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AdsPage(),
    );
  }
}

class AdsPage extends StatefulWidget {
  const AdsPage({super.key});

  @override
  AdsPageState createState() => AdsPageState();
}

class AdsPageState extends State<AdsPage> {
  @override
  void initState() {
    super.initState();
    FacebookAudienceNetwork.init(
      testingId: "a77955ee-3304-4635-be65-81029b0f5201",
      iOSAdvertiserTrackingEnabled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: FacebookBannerAd(
          placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047",
          bannerSize: BannerSize.STANDARD,
          listener: (result, value) {},
        ),
      ),
    );
  }
}
