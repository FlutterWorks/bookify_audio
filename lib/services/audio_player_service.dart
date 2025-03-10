import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:assets_audio_player_plus/assets_audio_player.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import '../models/models.dart';
import '../services/download_service.dart';

class AudioPlayerService {
  // YouTube extractor
  final YoutubeExplode _youtubeExplode = YoutubeExplode();

  // Platform-specific audio players
  final AssetsAudioPlayerPlus _mobilePlayer = AssetsAudioPlayerPlus.newPlayer();
  final just_audio.AudioPlayer _desktopPlayer = just_audio.AudioPlayer();

  // Download service
  final DownloadService _downloadService = DownloadService();

  // Current state
  AudioPlayerState _state = AudioPlayerState();

  // Getters
  AudioPlayerState get state => _state;
  bool get isPlaying => _state.isPlaying;
  bool get isLoading => _state.isLoading;
  Duration get position => _state.position;
  Duration get duration => _state.duration;
  Episode? get currentEpisode => _state.currentEpisode;
  Book? get currentBook => _state.currentBook;
  Author? get currentAuthor => _state.currentAuthor;

  // Stream controllers for state updates
  final _stateController = ValueNotifier<AudioPlayerState>(AudioPlayerState());
  ValueNotifier<AudioPlayerState> get stateStream => _stateController;

  AudioPlayerService() {
    _initListeners();
  }

  void _initListeners() {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      // Mobile listeners
      _mobilePlayer.currentPosition.listen((position) {
        _updateState(position: position);
      });

      _mobilePlayer.current.listen((playingAudio) {
        if (playingAudio != null) {
          _updateState(duration: playingAudio.audio.duration);
        }
      });

      _mobilePlayer.isPlaying.listen((playing) {
        _updateState(isPlaying: playing);
      });
    } else {
      // Desktop listeners with just_audio
      _desktopPlayer.positionStream.listen((position) {
        _updateState(position: position);
      });

      _desktopPlayer.durationStream.listen((duration) {
        if (duration != null) {
          _updateState(duration: duration);
        }
      });

      _desktopPlayer.playerStateStream.listen((state) {
        _updateState(isPlaying: state.playing);

        // Update loading state based on processing state
        if (state.processingState == just_audio.ProcessingState.loading ||
            state.processingState == just_audio.ProcessingState.buffering) {
          _updateState(isLoading: true);
        } else {
          _updateState(isLoading: false);
        }
      });
    }
  }

  void _updateState({
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    Duration? duration,
    Episode? currentEpisode,
    Book? currentBook,
    Author? currentAuthor,
    String? audioUrl,
    double? playbackSpeed,
    bool? isDownloaded,
    String? localFilePath,
    bool? isDownloading,
    double? downloadProgress,
  }) {
    _state = _state.copyWith(
      isPlaying: isPlaying,
      isLoading: isLoading,
      position: position,
      duration: duration,
      currentEpisode: currentEpisode,
      currentBook: currentBook,
      currentAuthor: currentAuthor,
      audioUrl: audioUrl,
      playbackSpeed: playbackSpeed,
      isDownloaded: isDownloaded,
      localFilePath: localFilePath,
      isDownloading: isDownloading,
      downloadProgress: downloadProgress,
    );

    _stateController.value = _state;
  }

  // Update download status
  void updateDownloadStatus(
    bool isDownloading, 
    double progress, {
    bool? isDownloaded,
    String? localFilePath,
  }) {
    _updateState(
      isDownloading: isDownloading,
      downloadProgress: progress,
      isDownloaded: isDownloaded,
      localFilePath: localFilePath,
    );
  }

  Future<void> playEpisode(Episode episode, Book book, Author author) async {
    try {
      // Check if the same episode is already playing
      if (currentEpisode != null && 
          currentEpisode!.id == episode.id && 
          isPlaying) {
        // Same episode is already playing, just return
        return;
      }
      
      // If a different episode is playing, stop it first
      if (isPlaying) {
        await stop();
      }

      // Reset download status when loading a new episode
      _updateState(
        isLoading: true,
        currentEpisode: episode,
        currentBook: book,
        currentAuthor: author,
        isDownloaded: false,
        localFilePath: null,
        isDownloading: false,
        downloadProgress: 0.0,
      );

      // Check if the episode is downloaded
      final isDownloaded = await _downloadService.isEpisodeDownloaded(episode);
      String? localFilePath;
      String? audioUrl;

      if (isDownloaded) {
        // Use local file if downloaded
        localFilePath = await _downloadService.getLocalFilePath(episode);
        _updateState(
          isDownloaded: true,
          localFilePath: localFilePath,
        );
      } else {
        // Extract audio URL from YouTube
        final videoId = _extractVideoId(episode.audioUrl);
        if (videoId == null) {
          throw Exception('Invalid YouTube URL');
        }

        final manifest =
            await _youtubeExplode.videos.streamsClient.getManifest(videoId);

        final audioStreamInfo = manifest.audioOnly.withHighestBitrate();
        audioUrl = audioStreamInfo.url.toString();
        _updateState(audioUrl: audioUrl);
      }

      // Play audio based on platform
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await _mobilePlayer.stop();
        
        if (isDownloaded && localFilePath != null) {
          // Play local file
          await _mobilePlayer.open(
            Audio.file(
              localFilePath,
              metas: Metas(
                title: episode.bookName,
                artist: author.name,
                album: book.title,
                image: MetasImage.network(book.cover),
              ),
            ),
            showNotification: true,
            notificationSettings: NotificationSettings(
              seekBarEnabled: true,
              stopEnabled: true,
              customPlayPauseAction: (player) {
                player.playOrPause();
              },
            ),
          );
        } else if (audioUrl != null) {
          // Stream from network
          await _mobilePlayer.open(
            Audio.network(
              audioUrl,
              metas: Metas(
                title: episode.bookName,
                artist: author.name,
                album: book.title,
                image: MetasImage.network(book.cover),
              ),
            ),
            showNotification: true,
            notificationSettings: NotificationSettings(
              seekBarEnabled: true,
              stopEnabled: true,
              customPlayPauseAction: (player) {
                player.playOrPause();
              },
            ),
          );
        }
      } else {
        // Use just_audio for desktop platforms
        await _desktopPlayer.stop();

        // Set audio source and metadata
        final audioSource = isDownloaded && localFilePath != null
            ? just_audio.AudioSource.uri(
                Uri.file(localFilePath),
                tag: MediaItem(
                  id: episode.id,
                  title: episode.bookName,
                  artist: author.name,
                  album: book.title,
                  artUri: Uri.parse(book.cover),
                ),
              )
            : just_audio.AudioSource.uri(
                Uri.parse(audioUrl!),
                tag: MediaItem(
                  id: episode.id,
                  title: episode.bookName,
                  artist: author.name,
                  album: book.title,
                  artUri: Uri.parse(book.cover),
                ),
              );

        await _desktopPlayer.setAudioSource(audioSource);
        await _desktopPlayer.play();
      }

      _updateState(isLoading: false, isPlaying: true);
    } catch (e) {
      _updateState(isLoading: false, isPlaying: false);
      rethrow;
    }
  }

  // Helper method to extract YouTube video ID
  String? _extractVideoId(String url) {
    try {
      return VideoId.parseVideoId(url);
    } catch (e) {
      return null;
    }
  }

  Future<void> play() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await _mobilePlayer.play();
    } else {
      await _desktopPlayer.play();
    }
    _updateState(isPlaying: true);
  }

  Future<void> pause() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await _mobilePlayer.pause();
    } else {
      await _desktopPlayer.pause();
    }
    _updateState(isPlaying: false);
  }

  Future<void> seek(Duration position) async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await _mobilePlayer.seek(position);
    } else {
      await _desktopPlayer.seek(position);
    }
    _updateState(position: position);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await _mobilePlayer.setPlaySpeed(speed);
    } else {
      await _desktopPlayer.setSpeed(speed);
    }
    _updateState(playbackSpeed: speed);
  }

  Future<void> stop() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await _mobilePlayer.stop();
    } else {
      await _desktopPlayer.stop();
    }
    _updateState(
      isPlaying: false,
      position: Duration.zero,
    );
  }

  void dispose() {
    _mobilePlayer.dispose();
    _desktopPlayer.dispose();
    _youtubeExplode.close();
  }
}
