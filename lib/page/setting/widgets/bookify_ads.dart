// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookifyAds extends StatefulWidget {
  final String apiUrl;
  const BookifyAds({super.key, required this.apiUrl});

  @override
  BookifyAdsState createState() => BookifyAdsState();
}

class BookifyAdsState extends State<BookifyAds> {
  // Variables to hold API data
  String? url;
  String? image;
  String? main1Name;
  String? main2Name;
  bool isLoading = true;

  // Fetch data from API
  Future<void> fetchData() async {
    final apiUrl = widget.apiUrl;

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          url = data['url'];
          image = data['image'];
          main1Name = data['main1Name'];
          main2Name = data['main2Name'];
          isLoading = false;
        });
      } else {
        // Handle the error
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle the exception
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GestureDetector(
      onTap: () async {
        if (url != null) {
          final Uri playStoreAppUrl = Uri.parse(url!);
          final Uri webUrl = Uri.parse(url!);

          if (await canLaunch(playStoreAppUrl.toString())) {
            await launch(playStoreAppUrl.toString());
          } else {
            await launch(webUrl.toString());
          }
        }
      },
      child: Card(
        child: SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    Image.network(
                      image ?? '',
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                    const SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          main1Name ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          main2Name ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Text("Install"),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
