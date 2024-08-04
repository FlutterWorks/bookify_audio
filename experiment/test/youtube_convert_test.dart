// import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// Future<void> main() async {
//   final yt = YoutubeExplode();
//   const videoId = 'https://www.youtube.com/watch?v=iJ58sv6SCrw';
//   final manifestAudio = await yt.videos.streams.getManifest(videoId);
//   final manifestVideo = await yt.videos.streams.getManifest(videoId);
//   final streamAudio = manifestAudio.audioOnly.first;
//   final streamVideo = manifestVideo.videoOnly.withHighestBitrate();
//   final audioUrl = streamAudio.url.toString();
//   final videoUrl = streamVideo.url.toString();
//   print('audio ---->    $audioUrl');
//   print('\n \n \n');
//   print('video ---->    $videoUrl');
//   print('\n \n \n');
//   final video = await yt.videos.get(videoId);
//   print(video.title);
//   print(video.description);
//   print(video.duration);
//   print(video.thumbnails);
//   print(video.id);
// }