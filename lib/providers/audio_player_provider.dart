import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/audio_player_service.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  
  // Getters to expose the service state
  AudioPlayerState get state => _audioPlayerService.state;
  bool get isPlaying => _audioPlayerService.isPlaying;
  bool get isLoading => _audioPlayerService.isLoading;
  Duration get position => _audioPlayerService.position;
  Duration get duration => _audioPlayerService.duration;
  Episode? get currentEpisode => _audioPlayerService.currentEpisode;
  Book? get currentBook => _audioPlayerService.currentBook;
  Author? get currentAuthor => _audioPlayerService.currentAuthor;
  double get playbackSpeed => _audioPlayerService.state.playbackSpeed;
  
  // Mini player visibility
  bool _isMiniPlayerVisible = false;
  bool get isMiniPlayerVisible => _isMiniPlayerVisible && currentEpisode != null;
  
  AudioPlayerProvider() {
    _audioPlayerService.stateStream.addListener(_onStateChanged);
  }
  
  void _onStateChanged() {
    // Show mini player when an episode is loaded
    if (currentEpisode != null && !_isMiniPlayerVisible) {
      _isMiniPlayerVisible = true;
    }
    
    notifyListeners();
  }
  
  // Player control methods
  Future<void> playEpisode(Episode episode, Book book, Author author) async {
    await _audioPlayerService.playEpisode(episode, book, author);
    _isMiniPlayerVisible = true;
    notifyListeners();
  }
  
  Future<void> play() async {
    await _audioPlayerService.play();
    notifyListeners();
  }
  
  Future<void> pause() async {
    await _audioPlayerService.pause();
    notifyListeners();
  }
  
  Future<void> seek(Duration position) async {
    await _audioPlayerService.seek(position);
    notifyListeners();
  }
  
  Future<void> setPlaybackSpeed(double speed) async {
    await _audioPlayerService.setPlaybackSpeed(speed);
    notifyListeners();
  }
  
  Future<void> stop() async {
    await _audioPlayerService.stop();
    notifyListeners();
  }
  
  void hideMiniPlayer() {
    _isMiniPlayerVisible = false;
    notifyListeners();
  }
  
  void showMiniPlayer() {
    if (currentEpisode != null) {
      _isMiniPlayerVisible = true;
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    _audioPlayerService.stateStream.removeListener(_onStateChanged);
    _audioPlayerService.dispose();
    super.dispose();
  }
} 