import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ApiService {
  static const String baseUrl = 'https://gokeihub.github.io/bookify_api/new.json';
  static const String cacheKey = 'cached_authors';

  Future<List<Author>> fetchAuthors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        final List<dynamic> decodedData = jsonDecode(cachedData);
        return decodedData.map((json) => Author.fromJson(json)).toList();
      }

      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = jsonDecode(response.body);
        await prefs.setString(cacheKey, response.body);
        return decodedData.map((json) => Author.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load authors: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load authors: $e');
    }
  }
}