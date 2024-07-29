import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AudioPlayerScreen(),
    ),
  );
}

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late YoutubePlayerController _controller;
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'WRHz0g-GMVA', // Your video ID
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: true,
      ),
    );
    _controller.addListener(_listener);
  }

  void _listener() {
    if (_controller.value.isReady && !_controller.value.isFullScreen) {
      setState(() {
        _currentSliderValue = _controller.value.position.inSeconds.toDouble();
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Player')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Now playing: YouTube Audio'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatDuration(
                    Duration(
                      seconds: _currentSliderValue.toInt(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Slider(
                    value: _currentSliderValue,
                    min: 0,
                    max: _controller.metadata.duration.inSeconds.toDouble(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                      _controller.seekTo(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Text(_formatDuration(_controller.metadata.duration)),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
            Opacity(
              opacity: 0,
              child: SizedBox(
                height: 0,
                width: 0,
                child: YoutubePlayer(controller: _controller),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }
}
