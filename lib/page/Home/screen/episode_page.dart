import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../setting/widgets/bookify_ads.dart';
import 'audio_player_page.dart';

class EpisodeListPage extends StatefulWidget {
  final dynamic audiobook;

  const EpisodeListPage({super.key, required this.audiobook});

  @override
  State<EpisodeListPage> createState() => _EpisodeListPageState();
}

class _EpisodeListPageState extends State<EpisodeListPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BookifyAds(
        apiUrl: 'https://gokeihub.github.io/bookify_api/ads/episode.json',
      ),
      appBar: AppBar(
        title: Text(
          widget.audiobook['bookName'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
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
                        imageUrl: widget.audiobook['bookImage'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'নাম: ${widget.audiobook['bookName']}',
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
                    'লেখক: ${widget.audiobook['bookCreatorName']}',
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
                final episode = widget.audiobook['episodes'][index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioPlayerScreen(
                              episode: episode,
                              bookName: widget.audiobook['bookName'],
                              bookCreatorName:
                                  widget.audiobook['bookCreatorName'],
                              bookImage: widget.audiobook['bookImage'],
                              audioUrl: episode['audio_url'],
                              voiceOwner: episode['voice_owner'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              childCount: widget.audiobook['episodes'].length,
            ),
          ),
        ],
      ),
    );
  }
}
