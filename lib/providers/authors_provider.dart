import 'package:flutter/foundation.dart';
import '../models/author.dart';
import '../services/api_service.dart';

class AuthorsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Author> _authors = [];
  bool _isLoading = false;
  String? _error;

  List<Author> get authors => _authors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAuthors({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (forceRefresh) {
        // Force a refresh from the API
        _authors = await _apiService.fetchAuthors(forceRefresh: true);
      } else {
        // Use cached data if available
        _authors = await _apiService.fetchAuthors();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}