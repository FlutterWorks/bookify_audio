import 'book.dart';

class Author {
  final String id;
  final String name;
  final String image;
  final List<Book> books;

  Author({
    required this.id,
    required this.name,
    required this.image,
    required this.books,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    // Handle the _id field which is a nested object with $oid
    String id = '';
    if (json['_id'] is Map) {
      // Use string key for accessing the $oid field
      final idMap = json['_id'] as Map;
      id = idMap.containsKey('\$oid') ? idMap['\$oid']?.toString() ?? '' : '';
    } else {
      id = json['_id']?.toString() ?? '';
    }

    return Author(
      id: id,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      books: (json['books'] as List<dynamic>?)
              ?.map((bookJson) => Book.fromJson(bookJson))
              .toList() ??
          [],
    );
  }
} 