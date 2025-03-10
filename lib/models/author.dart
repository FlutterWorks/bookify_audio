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
    return Author(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      books: (json['books'] as List<dynamic>?)
              ?.map((bookJson) => Book.fromJson(bookJson))
              .toList() ??
          [],
    );
  }
} 