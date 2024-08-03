import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/page/Home/screen/episode_page.dart';

class SeeMoreGridWidget extends StatefulWidget {
  final String seemorepageListTile;
  final String seeMorePageListImage;
  final String dataSaveName;
  final String apiurl;
  final double imageHeight;
  final double imageWidth;

  const SeeMoreGridWidget({
    super.key,
    required this.apiurl,
    required this.dataSaveName,
    required this.seemorepageListTile,
    required this.seeMorePageListImage,
    required this.imageHeight,
    required this.imageWidth,
  });

  @override
  State<SeeMoreGridWidget> createState() => _SeeMoreGridWidgetState();
}

class _SeeMoreGridWidgetState extends State<SeeMoreGridWidget> {
  List<dynamic>? _audiobooks;
  bool _isLoading = true;
  String? _error;

  Future<void> fetchAudiobooks() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString(widget.dataSaveName);

    if (storedData != null) {
      setState(() {
        _audiobooks = jsonDecode(storedData)['audiobooks'];
        _isLoading = false;
      });
    } else {
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
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? Center(child: Text('Error: $_error'))
            : GridView.builder(
                itemCount: _audiobooks!.length,
                itemBuilder: (context, index) {
                  var book = _audiobooks![index];
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (b) => EpisodeListPage(
                              audiobook: book,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: widget.imageHeight,
                        width: widget.imageWidth,
                        child: CachedNetworkImage(
                          imageUrl: book[widget.seeMorePageListImage],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0,
                ),
              );
  }
}
