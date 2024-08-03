import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class AudioPlayerScreen extends StatefulWidget {
  final dynamic episode;
  final String title;
  final String bookCreatorName;
  final String bookImage;
  final String audioUrl;
  const AudioPlayerScreen({
    super.key,
    this.episode,
    required this.title,
    required this.bookCreatorName,
    required this.bookImage,
    required this.audioUrl,
  });

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _currentSliderValue = 0;
  double _playbackSpeed = 1.0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _error;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {

    try {
    final youtube = YoutubeExplode();
    final videoId = widget.audioUrl;
      final manifest = await youtube.videos.streams.getManifest(videoId);
      final streamInfo = manifest.audioOnly.first;
      final audioUrl = streamInfo.url.toString();

      await _audioPlayer.setUrl(audioUrl);
      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      });
      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _position = position;
          _currentSliderValue = _position.inSeconds.toDouble();
        });
      });

      // Start playing automatically
      _audioPlayer.play();
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load audio: $e';
      });
    }
  }

  void _playPause() {
    try {
      setState(() {
      if (_isPlaying) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.play();
      }
      _isPlaying = !_isPlaying;
    });
    } catch (e) {
      
    }
  }

  void _undo() {
    final newPosition = _position - Duration(seconds: 10);
    _audioPlayer.seek(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  void _redo() {
    final newPosition = _position + Duration(seconds: 10);
    _audioPlayer.seek(newPosition < _duration ? newPosition : _duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.episode['title'])),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: widget.bookImage,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              // height: 200,
              // width: 330,
              fit: BoxFit.fill,
            ),
            Text(widget.title),
            const SizedBox(height: 10),
            Text(widget.bookCreatorName),
            const SizedBox(height: 10),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Colors.red),
              )
            else
              Column(
                children: [
                  Slider(
                    value: _currentSliderValue,
                    min: 0,
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _formatDuration(_position),
                      ),
                      Text(_formatDuration(_duration)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownButton<double>(
                          value: _playbackSpeed,
                          items: const [
                            DropdownMenuItem(value: 0.25, child: Text('0.25x')),
                            DropdownMenuItem(value: 0.5, child: Text('0.5x')),
                            DropdownMenuItem(value: 0.6, child: Text('0.6x')),
                            DropdownMenuItem(value: 0.75, child: Text('0.75x')),
                            DropdownMenuItem(value: 1.0, child: Text('1.0x')),
                            DropdownMenuItem(value: 1.25, child: Text('1.25x')),
                            DropdownMenuItem(value: 1.4, child: Text('1.4x')),
                            DropdownMenuItem(value: 1.5, child: Text('1.5x')),
                            DropdownMenuItem(value: 1.75, child: Text('1.75x')),
                            DropdownMenuItem(value: 2.0, child: Text('2.0x')),
                            DropdownMenuItem(value: 2.5, child: Text('2.5x')),
                            DropdownMenuItem(value: 3.0, child: Text('3.0x')),
                            DropdownMenuItem(value: 3.5, child: Text('3.5x')),
                            DropdownMenuItem(value: 4.0, child: Text('4.0x')),
                            DropdownMenuItem(value: 4.5, child: Text('4.5x')),
                            DropdownMenuItem(value: 5.0, child: Text('5.0x')),
                            DropdownMenuItem(value: 5.5, child: Text('5.5x')),
                            DropdownMenuItem(value: 6.0, child: Text('6.0x')),
                          ],
                          onChanged: (double? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _playbackSpeed = newValue;
                                _audioPlayer.setSpeed(newValue);
                              });
                            }
                          },
                          hint: const Text('Playback Speed'),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: _playPause,
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                        ),
                        IconButton(
                          onPressed: _undo,
                          icon: const Icon(Icons.replay_10),
                        ),
                        IconButton(
                          onPressed: _redo,
                          icon: const Icon(Icons.forward_10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

