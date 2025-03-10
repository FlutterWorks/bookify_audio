class Episode {
  final String id;
  final String bookName;
  final String audioUrl;
  final String voiceOwner;

  Episode({
    required this.id,
    required this.bookName,
    required this.audioUrl,
    required this.voiceOwner,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['_id'] ?? '',
      bookName: json['book_name'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      voiceOwner: json['voice_owner'] ?? '',
    );
  }
} 