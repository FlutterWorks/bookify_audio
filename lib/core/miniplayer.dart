import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';

void main() => runApp(const MyApp());

final _navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miniplayer example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFAFAFA),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MiniplayerWillPopScope(
      onWillPop: () async {
        final NavigatorState? navigator =
            _navigatorKey.currentState as NavigatorState?;
        if (navigator == null || !navigator.canPop()) return true;
        navigator.pop();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Navigator(
              key: _navigatorKey,
              onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                settings: settings,
                builder: (BuildContext context) => const FirstScreen(),
              ),
            ),
            Miniplayer(
              minHeight: 70,
              maxHeight: MediaQuery.of(context).size.height*1,
              // onDismiss: ,
              builder: (height, percentage) {
                // If the player is small, only show the play button
                if (height <= 100) {
                  return _buildSmallPlayer();
                } 
                // If the player is expanded, show the full player with an image, slider, and controls
                else {
                  return _buildExpandedPlayer();
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          fixedColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            )
          ],
        ),
      ),
    );
  }

  // Function to build the small miniplayer UI
  Widget _buildSmallPlayer() {
    return Container(
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              // Play/pause functionality here
            },
          ),
        ],
      ),
    );
  }

  // Function to build the expanded miniplayer UI
  Widget _buildExpandedPlayer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image when player is expanded
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://via.placeholder.com/150'), // Placeholder image
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Slider for audio progress
          Slider(
            value: 0.5, // Current audio position
            onChanged: (value) {
              // Handle slider change here
            },
          ),
          const SizedBox(height: 8),

          // Play/Pause button
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              // Play/pause functionality here
            },
          ),
        ],
      ),
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo: FirstScreen')),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondScreen()),
              ),
              child: const Text('Open SecondScreen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const ThirdScreen()),
              ),
              child: const Text('Open ThirdScreen with root Navigator'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo: SecondScreen')),
      body: const Center(child: Text('SecondScreen')),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo: ThirdScreen')),
      body: const Center(child: Text('ThirdScreen')),
    );
  }
}
