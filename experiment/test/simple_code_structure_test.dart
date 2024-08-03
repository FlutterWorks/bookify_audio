import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audiobook App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudiobookListPage(),
    );
  }
}

class AudiobookListPage extends StatefulWidget {
  @override
  _AudiobookListPageState createState() => _AudiobookListPageState();
}

class _AudiobookListPageState extends State<AudiobookListPage> {
  List<dynamic> audiobooks = [];
  String audioTitle = '' ;

  @override
  void initState() {
    super.initState();
    loadAudiobooks();
  }

  Future<void> loadAudiobooks() async {
    final String response = await rootBundle.loadString('assets/audiobooks.json');
    final data = json.decode(response);
    setState(() {
      audiobooks = data['audiobooks'];
      audioTitle =  data['audiotile'];
      print(audiobooks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(audioTitle.toString()),
      ),
      body: ListView.builder(
        itemCount: audiobooks.length,
        itemBuilder: (context, index) {
          final audiobook = audiobooks[index];
          return ListTile(
            leading: Image.network(audiobook['image']),
            title: Text(audiobook['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EpisodeListPage(audiobook: audiobook),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EpisodeListPage extends StatelessWidget {
  final dynamic audiobook;

  EpisodeListPage({required this.audiobook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(audiobook['title']),
      ),
      body: ListView.builder(
        itemCount: audiobook['episodes'].length,
        itemBuilder: (context, index) {
          final episode = audiobook['episodes'][index];
          return ListTile(
            title: Text(episode['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioPlayerPage(episode: episode),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AudioPlayerPage extends StatelessWidget {
  final dynamic episode;

  AudioPlayerPage({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(episode['title']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Playing ${episode['title']}'),
            ElevatedButton(
              onPressed: () {
                // Implement audio playing functionality here
              },
              child: Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}
