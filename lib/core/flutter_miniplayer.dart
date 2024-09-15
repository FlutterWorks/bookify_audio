import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AudioPlayerProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audiobook Player',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
    );
  }
}

class AudioPlayerProvider extends ChangeNotifier {
  Map<String, dynamic>? _currentEpisode;

  Map<String, dynamic>? get currentEpisode => _currentEpisode;

  void setCurrentEpisode(Map<String, dynamic> episode) {
    _currentEpisode = episode;
    notifyListeners();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const LibraryPage(),
    const SearchPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerProvider>(
      builder: (context, audioPlayerProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              _pages[_selectedIndex],
              if (audioPlayerProvider.currentEpisode != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MiniPlayer(
                    currentEpisode: audioPlayerProvider.currentEpisode!,
                    onTap: () {
                      // Expand the miniplayer
                    },
                  ),
                ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}

class EpisodeListPage extends StatelessWidget {
  final Map<String, dynamic> audiobook;

  const EpisodeListPage({super.key, required this.audiobook});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerProvider>(
      builder: (context, audioPlayerProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              audiobook['bookName'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: audiobook['bookImage'],
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'নাম: ${audiobook['bookName']}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'লেখক: ${audiobook['bookCreatorName']}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final episode = audiobook['episodes'][index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              title: Text(
                                episode['bookName'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.navigate_next,
                                color: Colors.deepPurple,
                              ),
                              onTap: () {
                                audioPlayerProvider.setCurrentEpisode({
                                  ...episode,
                                  'bookImage': audiobook['bookImage'],
                                  'bookCreatorName': audiobook['bookCreatorName'],
                                });
                              },
                            ),
                          ),
                        );
                      },
                      childCount: audiobook['episodes'].length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: audioPlayerProvider.currentEpisode != null ? 70 : 0),
                  ),
                ],
              ),
              if (audioPlayerProvider.currentEpisode != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MiniPlayer(
                    currentEpisode: audioPlayerProvider.currentEpisode!,
                    onTap: () {
                      // Expand the miniplayer
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

///
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: const Center(
        child: Text('Library Page'),
      ),
    );
  }
}

///
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: const Center(
        child: Text('Search Page'),
      ),
    );
  }
}

///
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile Page'),
      ),
    );
  }
}

class MiniPlayer extends StatelessWidget {
  final Map<String, dynamic> currentEpisode;
  final VoidCallback onTap;

  const MiniPlayer({
    super.key,
    required this.currentEpisode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Miniplayer(
      minHeight: 70,
      maxHeight: MediaQuery.of(context).size.height,
      builder: (height, percentage) {
        if (percentage < 0.2) {
          return GestureDetector(
            onTap: onTap,
            child: Container(
              color: Colors.deepPurple.shade50,
              child: Row(
                children: [
                  Image.network(
                    currentEpisode['bookImage'],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentEpisode['bookName'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            currentEpisode['bookCreatorName'],
                            style: TextStyle(color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      // Add play/pause functionality
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return AudioPlayerScreen(
          episode: currentEpisode,
        );
      },
    );
  }
}

class AudioPlayerScreen extends StatelessWidget {
  final Map<String, dynamic> episode;

  const AudioPlayerScreen({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(episode['bookName']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              episode['bookImage'],
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              episode['bookName'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              episode['bookCreatorName'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {
                    // Add previous track functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    // Add play/pause functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {
                    // Add next track functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EpisodeListPage(audiobook: sampleAudiobook),
            ));
          },
          child: const Text('Open Sample Audiobook'),
        ),
      ),
    );
  }
}

// Sample data for testing
final Map<String, dynamic> sampleAudiobook = {
  'bookName': 'Sample Audiobook',
  'bookCreatorName': 'John Doe',
  'bookImage': 'https://i.postimg.cc/vB37vkP1/gora.jpg',
  'episodes': [
    {
      'bookName': 'Chapter 1',
      'audio_url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'voice_owner': 'Jane Smith',
    },
    {
      'bookName': 'Chapter 2',
      'audio_url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'voice_owner': 'Jane Smith',
    },
    {
      'bookName': 'Chapter 3',
      'audio_url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'voice_owner': 'Jane Smith',
    },
  ],
};