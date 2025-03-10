import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_player_provider.dart';
import '../models/models.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Episode episode = args['episode'] as Episode;
    final Book book = args['book'] as Book;
    final Author author = args['author'] as Author;

    return Scaffold(
      appBar: AppBar(
        title: Text(episode.bookName),
        elevation: 0,
      ),
      body: Consumer<AudioPlayerProvider>(
        builder: (context, audioPlayerProvider, child) {
          return Column(
            children: [
              // Book cover and info
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      
                      // Book cover
                      Hero(
                        tag: 'book-cover-${book.id}',
                        child: Container(
                          width: 200,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              
                              fit: BoxFit.cover,
                              errorWidget: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.book,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                );
                              }, imageUrl: book.cover,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Episode title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          episode.bookName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Author name
                      Text(
                        author.name,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Voice owner
                      Text(
                        'Voice: ${episode.voiceOwner}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Download button
                      _buildDownloadButton(context, audioPlayerProvider, episode),
                      
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              
              // Player controls
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Time and duration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(audioPlayerProvider.position),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          _formatDuration(audioPlayerProvider.duration),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    
                    // Progress slider
                    Slider(
                      value: audioPlayerProvider.position.inMilliseconds.toDouble(),
                      min: 0,
                      max: audioPlayerProvider.duration.inMilliseconds > 0
                          ? audioPlayerProvider.duration.inMilliseconds.toDouble()
                          : 1.0,
                      onChanged: (value) {
                        audioPlayerProvider.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                    
                    // Playback controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Rewind 10 seconds
                        IconButton(
                          icon: const Icon(Icons.replay_10, size: 32),
                          onPressed: () {
                            final newPosition = audioPlayerProvider.position - const Duration(seconds: 10);
                            audioPlayerProvider.seek(newPosition.isNegative ? Duration.zero : newPosition);
                          },
                        ),
                        
                        // Play/Pause
                        IconButton(
                          icon: Icon(
                            audioPlayerProvider.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            if (audioPlayerProvider.isPlaying) {
                              audioPlayerProvider.pause();
                            } else {
                              audioPlayerProvider.play();
                            }
                          },
                        ),
                        
                        // Forward 30 seconds
                        IconButton(
                          icon: const Icon(Icons.forward_30, size: 32),
                          onPressed: () {
                            final newPosition = audioPlayerProvider.position + const Duration(seconds: 30);
                            final maxPosition = audioPlayerProvider.duration;
                            audioPlayerProvider.seek(newPosition > maxPosition ? maxPosition : newPosition);
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Playback speed
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Speed: '),
                        DropdownButton<double>(
                          value: audioPlayerProvider.playbackSpeed,
                          items: const [
                            DropdownMenuItem(value: 0.5, child: Text('0.5x')),
                            DropdownMenuItem(value: 0.75, child: Text('0.75x')),
                            DropdownMenuItem(value: 1.0, child: Text('1.0x')),
                            DropdownMenuItem(value: 1.25, child: Text('1.25x')),
                            DropdownMenuItem(value: 1.5, child: Text('1.5x')),
                            DropdownMenuItem(value: 2.0, child: Text('2.0x')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              audioPlayerProvider.setPlaybackSpeed(value);
                            }
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildDownloadButton(
    BuildContext context, 
    AudioPlayerProvider audioPlayerProvider,
    Episode episode,
  ) {
    // Check if the episode is already downloaded
    if (audioPlayerProvider.isDownloaded && 
        audioPlayerProvider.currentEpisode?.id == episode.id) {
      return ElevatedButton.icon(
        icon: const Icon(Icons.delete),
        label: const Text('Delete Download'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        onPressed: () async {
          await audioPlayerProvider.deleteDownloadedEpisode(episode);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download deleted')),
          );
        },
      );
    }
    
    // Show download progress if downloading
    if (audioPlayerProvider.isDownloading && 
        audioPlayerProvider.currentEpisode?.id == episode.id) {
      return Column(
        children: [
          LinearProgressIndicator(
            value: audioPlayerProvider.downloadProgress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Downloading ${(audioPlayerProvider.downloadProgress * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            icon: const Icon(Icons.cancel),
            label: const Text('Cancel'),
            onPressed: () {
              audioPlayerProvider.cancelDownload();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download canceled')),
              );
            },
          ),
        ],
      );
    }
    
    // Show download button if not downloaded and not downloading
    return FutureBuilder<bool>(
      future: audioPlayerProvider.isEpisodeDownloaded(episode),
      builder: (context, snapshot) {
        final isDownloaded = snapshot.data ?? false;
        
        if (isDownloaded) {
          return ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('Delete Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await audioPlayerProvider.deleteDownloadedEpisode(episode);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download deleted')),
              );
            },
          );
        }
        
        return ElevatedButton.icon(
          icon: const Icon(Icons.download),
          label: const Text('Download for Offline'),
          onPressed: () async {
            await audioPlayerProvider.downloadEpisode(episode);
            if (audioPlayerProvider.isDownloaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download complete')),
              );
            }
          },
        );
      },
    );
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    return hours == '00' ? '$minutes:$seconds' : '$hours:$minutes:$seconds';
  }
} 