import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test/page/Home/screen/audio_player_page.dart';

class EpisodeListPage extends StatelessWidget {
  final dynamic audiobook;

  EpisodeListPage({required this.audiobook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(audiobook['title']),
      ),
      body: Center(
        child: Column(
          children: [
            CachedNetworkImage(imageUrl: audiobook['image']),
            Text(audiobook['title']),
            ListView.builder(
              shrinkWrap: true,
              itemCount: audiobook['episodes'].length,
              itemBuilder: (context, index) {
                final episode = audiobook['episodes'][index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: ListTile(
                      title: Text(episode['title']),
                      trailing: Icon(Icons.navigate_next),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioPlayerScreen(
                              episode: episode,
                              title: audiobook['title'],
                              bookCreatorName: audiobook['bookCreatorName'],
                              bookImage: audiobook['image'],
                              audioUrl: episode['audio_url'],
                              // bookCreatorName: audiobook['bookCreatorName'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class AudioPlayerPage extends StatelessWidget {
//   final dynamic episode;

//   AudioPlayerPage({required this.episode});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(episode['title']),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Playing ${episode['title']}'),
//             ElevatedButton(
//               onPressed: () {},
//               child: Text('Play'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


