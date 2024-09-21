// import 'package:flutter/material.dart';
// import 'package:startapp_sdk/startapp.dart';

// class Advertisement extends StatefulWidget {
//   const Advertisement({super.key});

//   @override
//   State<Advertisement> createState() => _AdvertisementState();
// }

// class _AdvertisementState extends State<Advertisement> {
//   var startApp = StartAppSdk();
//   StartAppBannerAd? bannerAds;

//   loadBannerAds() {
//      
//     startApp.loadBannerAd(StartAppBannerType.BANNER).then((value) {
//       setState(() {
//         bannerAds = value;
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadBannerAds();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return bannerAds != null
//         ? SizedBox(height: 60, child: StartAppBanner(bannerAds!))
//         : const SizedBox();
//   }
// }
