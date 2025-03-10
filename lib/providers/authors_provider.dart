import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AuthorsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Author> _authors = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Author> get authors => _authors;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Fetch authors from API
  Future<void> fetchAuthors() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final authors = await _apiService.fetchAuthors();
      _authors = authors;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  
  // Get author by ID
  Author? getAuthorById(String id) {
    try {
      return _authors.firstWhere((author) => author.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get book by ID
  Book? getBookById(String authorId, String bookId) {
    try {
      final author = getAuthorById(authorId);
      if (author == null) return null;
      
      return author.books.firstWhere((book) => book.id == bookId);
    } catch (e) {
      return null;
    }
  }
  
  // Get episode by ID
  Episode? getEpisodeById(String authorId, String bookId, String episodeId) {
    try {
      final book = getBookById(authorId, bookId);
      if (book == null) return null;
      
      return book.episodes.firstWhere((episode) => episode.id == episodeId);
    } catch (e) {
      return null;
    }
  }
} 