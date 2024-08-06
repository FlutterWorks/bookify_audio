import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:test/page/Home/screen/slider_audio_player_page.dart';

class ImageSliderScreen extends StatefulWidget {
  const ImageSliderScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageSliderScreenState createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> {
  List<dynamic> _imageList = [];

  @override
  void initState() {
    super.initState();
    _loadStoredImages();
    _fetchImages();
  }

  Future<void> _loadStoredImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedImages = prefs.getString('imageList');
    if (storedImages != null) {
      setState(() {
        _imageList = json.decode(storedImages);
      });
    }
  }

  Future<void> _fetchImages() async {
    final response = await http.get(
        Uri.parse('https://apon10510.github.io/bookify_api/slider_api.json'));
    if (response.statusCode == 200) {
      setState(() {
        _imageList = json.decode(response.body);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('imageList', response.body);
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _imageList.isNotEmpty
        ? CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 16 / 9,
              enlargeCenterPage: true,
            ),
            items: _imageList.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SliderAudioPlayerScreen(
                              title: item['bookName'],
                              bookCreatorName: item['bookCreator'],
                              bookImage: item['image'],
                              audioUrl: item['audio_url'],
                              voiceOwner: item['voice_owner'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: 1000,
                            imageUrl: item['image'] ?? '',
                            placeholder: (context, url) => Container(
                              // width: imageWidth,
                              // height: imageHeight,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              // width: imageWidth,
                              // height: imageHeight,
                              color: Colors.grey[200],
                              child: const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ));
                },
              );
            }).toList(),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
