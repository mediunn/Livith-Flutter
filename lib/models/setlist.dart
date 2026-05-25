/// 셋리스트의 곡.
final class SetlistSong {
  const SetlistSong({required this.id, required this.title, this.order});

  final int id;
  final String title;
  final int? order;

  factory SetlistSong.fromJson(Map<String, dynamic> json) {
    return SetlistSong(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      order: json['order'] as int?,
    );
  }
}

/// 셋리스트.
///
/// iOS `Setlist` 대응.
final class Setlist {
  const Setlist({
    required this.id,
    required this.title,
    this.artist,
    this.songList = const [],
  });

  final int id;
  final String title;
  final String? artist;
  final List<SetlistSong> songList;

  factory Setlist.fromJson(Map<String, dynamic> json) {
    final songs = (json['songs'] as List<dynamic>?) ?? const [];
    return Setlist(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      artist: json['artist'] as String?,
      songList: songs
          .cast<Map<String, dynamic>>()
          .map(SetlistSong.fromJson)
          .toList(),
    );
  }
}
