import 'episode.dart';

class Book {
  final String id;
  final String title;
  final String cover;
  final List<Episode> episodes;

  Book({
    required this.id,
    required this.title,
    required this.cover,
    required this.episodes,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      cover: json['cover'] ?? '',
      episodes: (json['episodes'] as List<dynamic>?)
              ?.map((episodeJson) => Episode.fromJson(episodeJson))
              .toList() ??
          [],
    );
  }
} 