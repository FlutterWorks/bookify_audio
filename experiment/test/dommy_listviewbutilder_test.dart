import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (b) => BookList(index: index)));
            },
            child: Card(
              child: Text(data[index]["name"].toString()),
            ),
          );
        },
      ),
    );
  }
}

class BookList extends StatefulWidget {
  final int index;
  const BookList({super.key, required this.index});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  @override
  Widget build(BuildContext context) {
    final List<String> books = data[widget.index]["book"] as List<String>;

    return Scaffold(
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (b, index) {
          return Text(books[index]);
        },
      ),
    );
  }
}

const data = [
  {
    "name": "apon",
    "roll": 105,
    "class": 10,
    "goodBoy": true,
    "book": ["bangla", "english", "math"],
    "Mark": {"bangla": 161, "english": 169, "math": 80}
  },
  {
    "name": "apon",
    "roll": 105,
    "class": 10,
    "goodBoy": true,
    "book": ["Bangla", "English", "Math"],
    "Mark": {"bangla": 161, "english": 169, "math": 80}
  }
];
