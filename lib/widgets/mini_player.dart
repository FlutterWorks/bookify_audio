import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_player_provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerProvider>(
      builder: (context, audioPlayerProvider, child) {
        if (!audioPlayerProvider.isMiniPlayerVisible) {
          return const SizedBox.shrink();
        }

        final episode = audioPlayerProvider.currentEpisode;
        final book = audioPlayerProvider.currentBook;
        final author = audioPlayerProvider.currentAuthor;

        if (episode == null || book == null || author == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context, 
              '/player',
              arguments: {
                'episode': episode,
                'book': book,
                'author': author,
              },
            );
          },
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Progress bar
                LinearProgressIndicator(
                  value: audioPlayerProvider.duration.inMilliseconds > 0
                      ? audioPlayerProvider.position.inMilliseconds /
                          audioPlayerProvider.duration.inMilliseconds
                      : 0.0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  minHeight: 2,
                ),
                
                // Player controls and info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        // Book cover
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                          
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorWidget: (context, error, stackTrace) {
                              return Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                                child: const Icon(Icons.book, color: Colors.grey),
                              );
                            }, imageUrl: book.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Episode info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                episode.bookName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                author.name,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        // Play/Pause button
                        IconButton(
                          icon: Icon(
                            audioPlayerProvider.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            size: 36,
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
                        
                        // Close button
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            audioPlayerProvider.stop();
                            audioPlayerProvider.hideMiniPlayer();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 