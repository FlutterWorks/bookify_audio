// ignore_for_file: deprecated_member_use

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:startapp_sdk/startapp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

double currentSliderValue = 0;

class AudioPlayerScreen extends StatefulWidget {
  final dynamic episode;
  final String bookName;
  final String bookCreatorName;
  final String bookImage;
  final String audioUrl;
  final String voiceOwner;
  const AudioPlayerScreen({
    super.key,
    this.episode,
    required this.bookName,
    required this.bookCreatorName,
    required this.bookImage,
    required this.audioUrl,
    required this.voiceOwner,
  });

  @override
  AudioPlayerScreenState createState() => AudioPlayerScreenState();
}

class AudioPlayerScreenState extends State<AudioPlayerScreen>
    with WidgetsBindingObserver {
  late AssetsAudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = true;
  double _playbackSpeed = 1.0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  late SharedPreferences _prefs;
  var startApp = StartAppSdk();
  StartAppBannerAd? bannerAds;

  loadBannerAds() {
    startApp.setTestAdsEnabled(true);
    startApp.loadBannerAd(StartAppBannerType.BANNER).then((value) {
      setState(() {
        bannerAds = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AssetsAudioPlayer();
    _initializePlayer();
    loadBannerAds();
  }

  Future<void> _initializePlayer() async {
    _prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        _isLoading = true;
      });

      final youtube = YoutubeExplode();
      final videoId = widget.audioUrl;
      final manifest = await youtube.videos.streams.getManifest(videoId);
      final streamInfo = manifest.audioOnly.withHighestBitrate();
      final audioUrl = streamInfo.url.toString();

      final lastPosition =
          _prefs.getInt('lastPosition_${widget.audioUrl}') ?? 0;

      await _audioPlayer.open(
        Audio.network(
          audioUrl,
          metas: Metas(
            title: widget.bookName,
            artist: widget.bookCreatorName,
            album: widget.voiceOwner,
            image: MetasImage.network(widget.bookImage),
          ),
        ),
        autoStart: false,
        showNotification: true,
        notificationSettings: const NotificationSettings(),
        playInBackground: PlayInBackground.enabled,
        seek: Duration(seconds: lastPosition),
      );

      _audioPlayer.current.listen((playingAudio) {
        setState(() {
          _duration = playingAudio?.audio.duration ?? Duration.zero;
        });
      });

      _audioPlayer.currentPosition.listen((position) {
        setState(() {
          _position = position;
          currentSliderValue = _position.inSeconds.toDouble();
        });
        _savePosition();
      });

      await _audioPlayer.play();
      setState(() {
        _isPlaying = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _savePosition() {
    _prefs.setInt('lastPosition_${widget.audioUrl}', _position.inSeconds);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _savePosition();
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
      // Handle error
    }
  }

  void _undo() {
    final newPosition = _position - const Duration(seconds: 10);
    _audioPlayer
        .seek(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  void _redo() {
    final newPosition = _position + const Duration(seconds: 10);
    _audioPlayer.seek(newPosition < _duration ? newPosition : _duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.bookName)),
      bottomNavigationBar: bannerAds != null
          ? SizedBox(height: 60, child: StartAppBanner(bannerAds!))
          : const SizedBox(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
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
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: widget.bookImage,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.bookName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.bookCreatorName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Slider(
                          value: currentSliderValue,
                          min: 0,
                          max: _duration.inSeconds.toDouble(),
                          onChanged: (double value) {
                            setState(() {
                              currentSliderValue = value;
                            });
                            _audioPlayer.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(_formatDuration(_position)),
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
                                  DropdownMenuItem(
                                      value: 0.25, child: Text('0.25x')),
                                  DropdownMenuItem(
                                      value: 0.5, child: Text('0.5x')),
                                  DropdownMenuItem(
                                      value: 0.6, child: Text('0.6x')),
                                  DropdownMenuItem(
                                      value: 0.75, child: Text('0.75x')),
                                  DropdownMenuItem(
                                      value: 1.0, child: Text('1.0x')),
                                  DropdownMenuItem(
                                      value: 1.25, child: Text('1.25x')),
                                  DropdownMenuItem(
                                      value: 1.4, child: Text('1.4x')),
                                  DropdownMenuItem(
                                      value: 1.5, child: Text('1.5x')),
                                  DropdownMenuItem(
                                      value: 1.75, child: Text('1.75x')),
                                  DropdownMenuItem(
                                      value: 2.0, child: Text('2.0x')),
                                  DropdownMenuItem(
                                      value: 2.5, child: Text('2.5x')),
                                  DropdownMenuItem(
                                      value: 3.0, child: Text('3.0x')),
                                  DropdownMenuItem(
                                      value: 3.5, child: Text('3.5x')),
                                  DropdownMenuItem(
                                      value: 4.0, child: Text('4.0x')),
                                  DropdownMenuItem(
                                      value: 4.5, child: Text('4.5x')),
                                  DropdownMenuItem(
                                      value: 5.0, child: Text('5.0x')),
                                  DropdownMenuItem(
                                      value: 5.5, child: Text('5.5x')),
                                  DropdownMenuItem(
                                      value: 6.0, child: Text('6.0x')),
                                ],
                                onChanged: (double? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _playbackSpeed = newValue;
                                      _audioPlayer.setPlaySpeed(newValue);
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
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final String youtubeUrl =
                            'https://www.youtube.com/@${widget.voiceOwner}';
                        final String httpsRemove =
                            youtubeUrl.replaceAll('https:', 'vnd.youtube://');
                        final Uri youtubeAppUrl = Uri.parse(httpsRemove);
                        final Uri webUrl = Uri.parse(youtubeUrl);

                        if (await canLaunch(youtubeAppUrl.toString())) {
                          await launch(youtubeAppUrl.toString());
                        } else {
                          await launch(webUrl.toString());
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(150)),
                        child: const Center(
                          child: Text(
                            'Subscribe The Voice Owner',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.dispose();
  }
}
