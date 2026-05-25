/// 곡 가사(원문/발음/번역).
///
/// iOS `SongLyrics` 대응.
final class SongLyrics {
  const SongLyrics({
    required this.id,
    required this.title,
    required this.artist,
    this.lyricList = const [],
    this.pronunciationList = const [],
    this.translationList = const [],
    this.youtubeId,
  });

  final int id;
  final String title;
  final String artist;
  final List<String> lyricList;
  final List<String> pronunciationList;
  final List<String> translationList;
  final String? youtubeId;

  factory SongLyrics.fromJson(Map<String, dynamic> json) {
    List<String> stringList(String key) =>
        ((json[key] as List<dynamic>?) ?? const []).cast<String>();

    return SongLyrics(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      artist: json['artist'] as String? ?? '',
      lyricList: stringList('lyrics'),
      pronunciationList: stringList('pronunciation'),
      translationList: stringList('translation'),
      youtubeId: json['youtubeId'] as String?,
    );
  }
}
