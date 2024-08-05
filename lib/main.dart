import 'package:flutter/material.dart';
import 'package:test/page/Home/screen/home_page.dart';

void main() {
  runApp(
    const MyApp(),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Auto Image Slider')),
//         body:  ImageSlider(),
//       ),
//     );
//   }
// }

// class ImageSlider extends StatelessWidget {
//   final List<String> imgList = [
//     'https://i.postimg.cc/vB37vkP1/gora.jpg',
//     'https://i.postimg.cc/d00GV4Qw/kabuli-ola.jpg',
//     'https://i.postimg.cc/gjGzGBdK/ghore-baire.jpg',
//     'https://i.postimg.cc/HLj3hpyw/chokher-bali.jpg',
//     'https://i.postimg.cc/3xjHxFSS/chokher-bali2.jpg',
//   ];

//    ImageSlider({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider(
//       options: CarouselOptions(
//         autoPlay: true,
//         aspectRatio: 2.0,
//         enlargeCenterPage: true,
//       ),
//       items: imgList.map((item) => Center(
//         child: Image.network(item, fit: BoxFit.cover, width: 1000),
//       )).toList(),
//     );
//   }
// }