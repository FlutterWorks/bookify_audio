import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/page/Home/screen/writer_details_page.dart';

class WriterUtils extends StatefulWidget {
  const WriterUtils({super.key});

  @override
  State<WriterUtils> createState() => _WriterUtilsState();
}

class _WriterUtilsState extends State<WriterUtils> {
  List<dynamic> writerList = [];
  bool isLoading = true;
  bool _isDisposed = false;  // Track whether the widget has been disposed

  // Fetch writer data from API
  Future<void> getData() async {
    try {
      final res = await http.get(
        Uri.parse('https://apon06.github.io/bookify_api/writer.json'),
      );
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        if (!_isDisposed && mounted) {
          setState(() {
            writerList = decoded['WriterInfo'];
            isLoading = false;
          });
        }
        await saveDataToPreferences();
      } else {
        if (!_isDisposed && mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (!_isDisposed && mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Save fetched data to shared preferences
  Future<void> saveDataToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('WriterSaveKey', json.encode(writerList));
  }

  // Load saved data from shared preferences
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('WriterSaveKey');
    if (savedData != null) {
      if (!_isDisposed && mounted) {
        setState(() {
          writerList = json.decode(savedData);
          isLoading = false;
        });
      }
    }
    await getData();
  }

  // Refresh data by re-fetching from the API
  Future<void> refreshData() async {
    if (!_isDisposed && mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await getData();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _isDisposed = true;  // Set _isDisposed to true when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())  // Show loading spinner when loading
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: writerList.length,
              itemBuilder: (context, index) {
                var categoryApi = writerList[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WriterDetailsPage(
                          api: categoryApi["api"],
                          bookImage: categoryApi["bookImage"],
                          bookName: categoryApi["bookName"],
                          bookCreatorName: categoryApi["bookCreatorName"],
                          saveKey: categoryApi["saveKey"],
                          writerImage: categoryApi['writerImage'],
                        ),
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: CachedNetworkImageProvider(
                          categoryApi["writerImage"],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
