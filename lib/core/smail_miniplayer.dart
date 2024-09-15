import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../page/Home/screen/audio_player_page.dart';

class SmailMiniplayer extends StatefulWidget {
  final dynamic episode;
  final String bookName;
  final String bookCreatorName;
  final String bookImage;
  final String audioUrl;
  final String voiceOwner;
  const SmailMiniplayer({
    super.key,
    this.episode,
    required this.bookName,
    required this.bookCreatorName,
    required this.bookImage,
    required this.audioUrl,
    required this.voiceOwner,
  });

  @override
  SmailMiniplayerState createState() => SmailMiniplayerState();
}

class SmailMiniplayerState extends State<SmailMiniplayer>
    with WidgetsBindingObserver {
  late AssetsAudioPlayer _audioPlayer;
  // bool isLoading = true;
  Duration duration = Duration.zero;
  bool isPlaying = false;
  Duration _position = Duration.zero;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AssetsAudioPlayer();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        // isLoading = true;
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
          duration = playingAudio?.audio.duration ?? Duration.zero;
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
        isPlaying = true;
        // isLoading = false;
      });
    } catch (e) {
      setState(() {
        // isLoading = false;
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
        if (isPlaying) {
          _audioPlayer.pause();
        } else {
          _audioPlayer.play();
        }
        isPlaying = !isPlaying;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(widget.bookName)),
      body: IconButton(
        onPressed: _playPause,
        icon: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
