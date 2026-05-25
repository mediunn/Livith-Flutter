/// 아티스트.
///
/// iOS `PreferredArtist`/`Artist` 대응. `/search/artists` 응답에서 생성한다.
final class Artist {
  const Artist({
    required this.id,
    required this.name,
    this.imageUrl,
    this.genreId,
  });

  final int id;
  final String name;
  final String? imageUrl;
  final int? genreId;

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      genreId: json['genreId'] as int?,
    );
  }
}
