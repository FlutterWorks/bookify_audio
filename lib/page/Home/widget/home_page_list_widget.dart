import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:test/page/Home/screen/episode_page.dart';
import 'package:test/page/Home/screen/see_more.dart';

class HomePageListWidget extends StatefulWidget {
  final String homepageListTile;
  final String homepageListImage;
  final String seeMorePageListTitle;
  final String seeMorePageListCreatorName;
  final String dataSaveName;
  final String apiurl;

  const HomePageListWidget({
    super.key,
    required this.imageHeight,
    required this.imageWidth,
    required this.homepageListTile,
    required this.homepageListImage,
    required this.seeMorePageListTitle,
    required this.seeMorePageListCreatorName,
    required this.dataSaveName,
    required this.apiurl,
  });

  final double imageHeight;
  final double imageWidth;

  @override
  State<HomePageListWidget> createState() => _HomePageListWidgetState();
}

class _HomePageListWidgetState extends State<HomePageListWidget> {
  List<dynamic>? _audiobooks;
  bool _isLoading = true;
  String? _error;

  Future<void> fetchAudiobooks() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.get(Uri.parse(widget.apiurl));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        prefs.setString(widget.dataSaveName, response.body);
        setState(() {
          _audiobooks = json['audiobooks'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load audiobooks');
      }
    } catch (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
      // Fallback to local data if API request fails
      final storedData = prefs.getString(widget.dataSaveName);
      if (storedData != null) {
        setState(() {
          _audiobooks = jsonDecode(storedData)['audiobooks'];
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAudiobooks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                widget.homepageListTile,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (builder) => SeeMorePage(
                        apiurl: widget.apiurl,
                        dataSaveName: widget.dataSaveName,
                        seemorepageListTile: widget.homepageListTile,
                        seeMorePageListImage: widget.homepageListImage,
                        seeMorePageListTitle: widget.seeMorePageListTitle,
                        seeMorePageListCreatorName:
                            widget.seeMorePageListCreatorName,
                        imageHeight: widget.imageHeight,
                        imageWidth: widget.imageHeight,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'See More',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: widget.imageHeight + 10,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text('Error: $_error'))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _audiobooks!.length,
                      itemBuilder: (context, index) {
                        var book = _audiobooks![index];

                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (builder) =>
                                      EpisodeListPage(audiobook: book),
                                ),
                              );
                            },
                            child: CachedNetworkImage(
                              width: widget.imageWidth,
                              height: widget.imageHeight,
                              fit: BoxFit.cover,
                              imageUrl: book[widget.homepageListImage],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
