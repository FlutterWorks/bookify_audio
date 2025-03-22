import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://gokeihub.github.io/bookify_api/new.json';
  static const String cacheKey = 'cached_authors_data';

  // Fetch authors from API or cache
  Future<List<Author>> fetchAuthors({bool forceRefresh = false}) async {
    try {
      // If forceRefresh is true or we don't have cached data, fetch from API
      if (forceRefresh || !(await _hasCachedData())) {
        return await _fetchFromApi();
      }
      
      // Otherwise, try to load from cache first
      try {
        return await _loadAuthorsFromCache();
      } catch (cacheError) {
        // If cache fails, fall back to API
        print('Cache error: $cacheError');
        return await _fetchFromApi();
      }
    } catch (e) {
      print('Exception details: $e');
      // If there's an exception with API, try to load from cache
      try {
        return await _loadAuthorsFromCache();
      } catch (cacheError) {
        print('Cache error: $cacheError');
        throw Exception('Failed to load authors: $e');
      }
    }
  }

  // Helper method to check if we have cached data
  Future<bool> _hasCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(cacheKey);
    return jsonString != null && jsonString.isNotEmpty;
  }

  // Helper method to fetch from API
  Future<List<Author>> _fetchFromApi() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      // Print the raw response for debugging
      print('Raw API response: ${response.body}');
      
      final List<dynamic> decodedData = jsonDecode(response.body) as List<dynamic>;
      
      // Save the fresh data to SharedPreferences
      await _saveAuthorsToCache(response.body);
      
      // Process each item carefully with proper type checking
      return decodedData.map((item) {
        // Ensure each item is properly cast to Map<String, dynamic>
        if (item is Map) {
          return Author.fromJson(Map<String, dynamic>.from(item));
        } else {
          throw Exception('Invalid author data format: $item');
        }
      }).toList();
    } else {
      throw Exception('Failed to load authors: ${response.statusCode}');
    }
  }

  // Save authors data to SharedPreferences
  Future<void> _saveAuthorsToCache(String jsonData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(cacheKey, jsonData);
      print('Authors data saved to cache');
    } catch (e) {
      print('Failed to save authors to cache: $e');
    }
  }

  // Load authors data from SharedPreferences
  Future<List<Author>> _loadAuthorsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(cacheKey);
    
    if (jsonString == null || jsonString.isEmpty) {
      throw Exception('No cached data available');
    }
    
    print('Loading authors from cache');
    final List<dynamic> decodedData = jsonDecode(jsonString) as List<dynamic>;
    
    return decodedData.map((item) {
      if (item is Map) {
        return Author.fromJson(Map<String, dynamic>.from(item));
      } else {
        throw Exception('Invalid cached author data format');
      }
    }).toList();
  }
  
  // Check if there is newer data available
  Future<bool> hasNewData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(cacheKey);
      
      if (cachedData == null) return true;
      
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return response.body != cachedData;
      }
      return false;
    } catch (e) {
      print('Error checking for new data: $e');
      return false;
    }
  }
}

// const apiData = [{
//   "_id": {
//     "$oid": "67c3dfeca0eaea993eae8ca7"
//   },
//   "name": "রবীন্দ্রনাথ ঠাকুর",
//   "books": [
//     {
//       "title": "গোরা",
//       "cover": "https://i.postimg.cc/vB37vkP1/gora.jpg",
//       "_id": {
//         "$oid": "67c3dfeca0eaea993eae8ca8"
//       }
//     },
//     {
//       "title": "কাবুলিওয়ালা",
//       "cover": "https://i.postimg.cc/d00GV4Qw/kabuli-ola.jpg",
//       "_id": {
//         "$oid": "67c3dfeca0eaea993eae8ca9"
//       }
//     },
//     {
//       "title": "ঘরে বাইরে",
//       "cover": "https://i.postimg.cc/gjGzGBdK/ghore-baire.jpg",
//       "_id": {
//         "$oid": "67c3dfeca0eaea993eae8caa"
//       }
//     }
//   ],
//   "__v": 0
// },
// {
//   "_id": {
//     "$oid": "67c3dfeca0eaea993eae8cab"
//   },
//   "name": "শরৎচন্দ্র চট্টোপাধ্যায়",
//   "books": [
//     {
//       "title": "দেবদাস",
//       "cover": "https://i.postimg.cc/gJxRxfQ9/devdas.jpg",
//       "_id": {
//         "$oid": "67c3dfeca0eaea993eae8cac"
//       }
//     },
//     {
//       "title": "পরিণীতা",
//       "cover": "https://i.postimg.cc/Y01xS5Lr/Parineeta.jpg",
//       "_id": {
//         "$oid": "67c3dfeca0eaea993eae8cad"
//       }
//     },
//     {
//       "title": "চরিত্রহীন",
//       "cover": "https://i.postimg.cc/nzfjLC4m/Charitraheen.jpg",
//       "_id": {
//         "$oid": "67c3dfeca0eaea993eae8cae"
//       }
//     }
//   ],
//   "__v": 0
// },
// {
//   "_id": {
//     "$oid": "67c3dfeca0eaea993eae8caf"
//   },
//   "name": "কাজী নজরুল ইসলাম",
//   "books": [
//     {
//       "title": "বিবের বাঁশী",
//       "cover": "https://i.postimg.cc/8zgJt7jC/bisher-bashi.jpg",
//       "_id": {
//         "$oid": "67c3dfeca0eaea993eae8cb0"
//       }
//     },
//     {
//       "title": "বাঁধন-হারা",
//       "cover": "https://i.postimg.cc/yxSh32rp/Bandhan-Hara.jpg",
//       "_id": {
//         "$oid": "67c3dfeca0eaea993eae8cb1"
//       }
//     },
//     {
//       "title": "মৃত্যুক্ষুধা",
//       "cover": "https://i.postimg.cc/d3qBp5W5/Mrityukshuda.jpg",
//       "_id": {
//         "$oid": "67c3dfeca0eaea993eae8cb2"
//       }
//     }
//   ],
//   "__v": 0
// },
// {
//   "_id": {
//     "$oid": "67c3e028a0eaea993eae8cc2"
//   },
//   "name": "ajju sexy",
//   "books": [
//     {
//       "title": "das",
//       "cover": "https://i.postimg.cc/mrMbKJG7/himu.jpg",
//       "_id": {
//         "$oid": "67c3e043a0eaea993eae8cd0"
//       }
//     },
//     {
//       "title": "jgfghfgh",
//       "cover": "https://i.postimg.cc/sDv1wn14/nondiko-noroke.jpg",
//       "_id": {
//         "$oid": "67c3e1cfa0eaea993eae8cf9"
//       }
//     },
//     {
//       "title": "dsfdsfsssssssssssssssss",
//       "cover": "https://yt3.ggpht.com/KVjptxDSWT7rjVfGax2TgTNVAYgplgo1z_fwaV3MFjPpcmNVZC0TIgQV030BPJ0ybCP3_Fz-2w=s88-c-k-c0x00ffffff-no-rj",
//       "_id": {
//         "$oid": "67c3e669a0eaea993eae8d6d"
//       }
//     },
//     {
//       "title": "gfgddg",
//       "cover": "https://fonts.gstatic.com/s/e/notoemoji/15.1/1f601/72.png",
//       "_id": {
//         "$oid": "67c3e71ba0eaea993eae8db4"
//       }
//     }
//   ],
//   "__v": 4
// },
// {
//   "_id": {
//     "$oid": "67c3e764a0eaea993eae8dee"
//   },
//   "name": "ajju bhai sexy",
//   "books": [],
//   "__v": 0
// }]